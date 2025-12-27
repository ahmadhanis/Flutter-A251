<?php
	header("Access-Control-Allow-Origin: *");
	use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require "/home4/slumber6/PHPMailer/src/Exception.php";
    require "/home4/slumber6/PHPMailer/src/PHPMailer.php";
    require "/home4/slumber6/PHPMailer/src/SMTP.php";

	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	if (!isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}

	$email = $_POST['email'];
	$name = $_POST['name'];
	$phone = $_POST['phone'];
	
	$address = $_POST['address'];
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];

	$password = $_POST['password'];
	$hashedpassword = sha1($password);
	$otp = rand(100000, 999999);
	$credit = 5;
	// Check if email already exists
	$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `user_email` = '$email'";
	$result = $conn->query($sqlcheckmail);
	if ($result->num_rows > 0){
		$response = array('status' => 'failed', 'message' => 'Email already registered');
		sendJsonResponse($response);
		exit();
	}
	// Insert new user into database
	$sqlregister = "INSERT INTO `tbl_users`(`user_email`, `user_name`, `user_phone`, `user_address`, `user_latitude`, `user_longitude`, `user_password`, `user_otp`, `user_credit`) 
	VALUES ('$email','$name','$phone','$address','$latitude','$longitude', '$hashedpassword','$otp',$credit)";
	try{
		if ($conn->query($sqlregister) === TRUE){
			$response = array('status' => 'success', 'message' => 'User registered successfully');
			sendMail($email,$name,$otp);
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'User registration failed');
			sendJsonResponse($response);
		}
	}catch(Exception $e){
		$response = array('status' => 'failed', 'message' => $e->getMessage());
		sendJsonResponse($response);
	}


//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function sendMail($email,$name,$otp){
    // Send verification email
        $mail = new PHPMailer(true);
        try {
            $mail->isSMTP();
            $mail->Host = ''; // Replace with your SMTP host
            $mail->SMTPAuth = true;
            $mail->Username = ''; // Replace with your SMTP username
            $mail->Password = ''; // Replace with your SMTP password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
            $mail->Port = 465;

            // Email content
            $mail->setFrom('yourservermail', 'MyFuWu App Mailer'); // Replace with your "from" email
            $mail->addAddress($email, $name);
            $mail->isHTML(true);
            $mail->Subject = 'MyFuWu Registration Verification';
            $mail->Body = "<html><p>Welcome to MyFuWu</p>
            <p>The following is your verification link. Please click on the link to verify your account.<br><a href='https://slumberjer.com/myfuwu/api/verify.php?otp=$otp&email=$email'>Click Here to Verify</a></p><html>
            ";


            $mail->send();
          //  echo "Send Mail Success";
        } catch (Exception $e) {
            echo $mail->ErrorInfo;
        }
}

?>