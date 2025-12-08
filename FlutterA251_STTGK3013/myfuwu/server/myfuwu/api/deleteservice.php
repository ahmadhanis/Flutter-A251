<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	$userid = $_POST['userid'];
	$serviceid = $_POST['serviceid'];
	
	// Delete service from database
	$deleteservice = "DELETE FROM `tbl_services` WHERE `service_id` = '$serviceid' AND `user_id` = '$userid'"; 
	try{
		if ($conn->query($deleteservice) === TRUE){
			$response = array('status' => 'success', 'message' => 'Service delete successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Service not deleted');
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