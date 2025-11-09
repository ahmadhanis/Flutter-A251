<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	$userid = $_POST['userid'];
	$title = addslashes($_POST['title']);
	$service = $_POST['service'];
	$district = $_POST['district'];
	$hourlyrate = $_POST['hourlyrate'];
	$description = addslashes($_POST['description']);
	$encodedimage = base64_decode($_POST['image']);

	// Insert new service into database
	$sqlinsertservice = "INSERT INTO `tbl_services`(`user_id`, `service_title`, `service_desc`, `service_district`, `service_type`, `service_rate`) 
	VALUES ('$userid','$title','$description','$district','$service','$hourlyrate')";
	try{
		if ($conn->query($sqlinsertservice) === TRUE){
			$last_id = $conn->insert_id;
			$path = "../assets/services/service_".$last_id.".png";
			file_put_contents($path, $encodedimage);

			$response = array('status' => 'success', 'message' => 'Service added successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Service not added');
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


?>