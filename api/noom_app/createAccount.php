<?php
	require("conn.php");
	
	$msg = array();
	$name = $_POST['name'];
	$mobile = $_POST['mobile'];
	$email = $_POST['email'];
	$username = $_POST['username'];
	$password = $_POST['password'];

	$sql="INSERT INTO parent VALUES(NULL, '$name', '$mobile', '$email', '$username', '$password')";

	$result= mysqli_query($connection,$sql);
	if($result) {
		$msg[] = ['done'=>'true'];
	} else {
		$msg[] = ['done'=>'false'];
	}

	echo json_encode($msg);

?>