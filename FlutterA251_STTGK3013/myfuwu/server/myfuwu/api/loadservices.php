<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';
    $sqlloadservices = "SELECT * FROM `tbl_services`";
    $result = $conn->query($sqlloadservices);
    if ($result->num_rows > 0) {
        $servicedata = array();
        while ($row = $result->fetch_assoc()) {
            $servicedata[] = $row;
        }
        $response = array('status' => 'success','data' => $servicedata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data'=>null);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed');
    sendJsonResponse($response);
    exit();
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>