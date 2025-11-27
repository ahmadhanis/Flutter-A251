<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (!isset($_GET['userid'])) {
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    $userid = $_GET['userid'];
    include 'dbconnect.php';
    $sqlgetuser = "SELECT * FROM `tbl_users` WHERE `user_id` = '$userid'";
    $result = $conn->query($sqlgetuser);
    if ($result->num_rows > 0) {
        $userdata = array();
        while ($row = $result->fetch_assoc()) {
            $userdata[] = $row;
        }
        $response = array('status' => 'success', 'message' => 'Success', 'data' => $userdata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Invalid request','data'=>null);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>