<?php
	$email = $_POST['email'];
	$password = $_POST['password'];
	$data = array('email' => $email, 'password' => $password);
	echo json_encode($data);
?>