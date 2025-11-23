<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $_GET['search'];
        $sqlloadservices = "SELECT * FROM `tbl_services` WHERE `service_desc` LIKE '%$search%' ORDER BY `service_id` DESC";    
    }else{
        $sqlloadservices = "SELECT * FROM `tbl_services` ORDER BY `service_id` DESC";
    }
    
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