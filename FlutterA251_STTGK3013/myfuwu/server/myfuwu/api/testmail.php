<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require "/home4/slumber6/PHPMailer/src/Exception.php";
require "/home4/slumber6/PHPMailer/src/PHPMailer.php";
require "/home4/slumber6/PHPMailer/src/SMTP.php";

sendMail("slumberjer@gmail.com");


function sendMail($email){
    // Send verification email
        $mail = new PHPMailer(true);
        try {
            $mail->isSMTP();
            $mail->Host = 'mail.slumberjer.com'; // Replace with your SMTP host
            $mail->SMTPAuth = true;
            $mail->Username = 'myfuwu@slumberjer.com'; // Replace with your SMTP username
            $mail->Password = '6YE20e4vYwHK'; // Replace with your SMTP password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
            $mail->Port = 465;

            // Email content
            $mail->setFrom('myfuwu@slumberjer.com', 'MyFuWu App Mailer'); // Replace with your "from" email
            $mail->addAddress($email, "User");
            $mail->isHTML(true);
            $mail->Subject = 'MyFuWu App';
            $mail->Body = "Welcome to MyFuWu";


            $mail->send();
            echo "Send Mail Success";
        } catch (Exception $e) {
            echo $mail->ErrorInfo;
        }
}


?>

