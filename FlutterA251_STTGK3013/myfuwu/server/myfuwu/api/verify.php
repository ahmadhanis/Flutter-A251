<?php
if (isset($_GET['email']) && isset($_GET['otp'])){
    include_once("dbconnect.php");

        $useremail = $_GET['email'];
        $otp = $_GET['otp'];
        $newotp = '1';
        $sqlcheck = "SELECT * FROM `tbl_users` WHERE user_email = '$useremail' AND user_otp = '$otp'";
        
        $result = $conn->query($sqlcheck);
        $number_of_result = $result->num_rows;
        if ($result->num_rows > 0) {
            $sqlverify = "UPDATE `tbl_users` SET `user_otp`='$newotp' WHERE user_email= '$useremail'";
            if ($conn->query($sqlverify) === TRUE) {
                 echo "<script>alert('Verification Success. You can now login using the app');</script>";
            }else{
                 echo "<script>alert('Verification Failed');</script>";
            }
        }
}

?>