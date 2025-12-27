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
	$title = addslashes($_POST['title']);
	$service = $_POST['service'];
	$district = $_POST['district'];
	$hourlyrate = $_POST['hourlyrate'];
	$description = addslashes($_POST['description']);
	$image = $_POST['image'];
	if ($image == "NA") {
		$encodedimage = "NA";	
	}else{
		$encodedimage = base64_decode($_POST['image']);
	}
	

	// Insert new service into database
	$sqlupdateservice = "UPDATE `tbl_services` SET `service_title`='$title',`service_desc`='$description',
	`service_district`='$district',`service_type`='$service',`service_rate`='$hourlyrate' 
	WHERE `service_id` = '$serviceid' AND `user_id` = '$userid';";
	try{
		if ($conn->query($sqlupdateservice) === TRUE){
			$path = "../assets/services/service_".$serviceid.".png";
			if ($encodedimage != "NA") {
				file_put_contents($path, $encodedimage);	
			}
			$response = array('status' => 'success', 'message' => 'Service updated successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Service update failed');
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