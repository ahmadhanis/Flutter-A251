<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}

// ---------- Get POST data ----------
$userid    = $_POST['user_id'];
$name      = addslashes($_POST['user_name']);
$phone     = addslashes($_POST['user_phone']);
$address   = addslashes($_POST['user_address']);
$latitude  = $_POST['user_latitude'];
$longitude = $_POST['user_longitude'];

// ---------- SQL UPDATE ----------
$sqlupdateprofile = "
UPDATE tbl_users 
SET 
    user_name      = '$name',
    user_phone     = '$phone',
    user_address   = '$address',
    user_latitude  = '$latitude',
    user_longitude = '$longitude'
WHERE user_id = '$userid'
";

try {
    if ($conn->query($sqlupdateprofile) === TRUE) {
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Profile updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Profile update failed'
        ]);
    }
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

// ---------- JSON response ----------
function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>
