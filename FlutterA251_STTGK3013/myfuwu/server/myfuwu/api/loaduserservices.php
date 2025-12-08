<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['userid'])) {
    include 'dbconnect.php';
    
    $userid = $_GET['userid'];

    // Base JOIN query
    $query = "
        SELECT 
            s.service_id,
            s.user_id,
            s.service_title,
            s.service_desc,
            s.service_district,
            s.service_type,
            s.service_rate,
            s.service_date,
            u.user_name,
            u.user_email,
            u.user_phone,
            u.user_regdate
        FROM tbl_services s
        JOIN tbl_users u ON s.user_id = '$userid' WHERE u.user_id = '$userid'";


    // Execute query
    $result = $conn->query($query);

    if ($result && $result->num_rows > 0) {
        $servicedata = array();
        while ($row = $result->fetch_assoc()) {
            $servicedata[] = $row;
        }
        $response = array('status' => 'success', 'data' => $servicedata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }

} else {
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
