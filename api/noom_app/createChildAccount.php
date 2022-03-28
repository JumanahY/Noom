<?php
	require("conn.php");
	
	$msg = array();
	$name = $_POST['name'];
	$parent_id = $_POST['parent_id'];
	$age = $_POST['age'];
	$username = $_POST['username'];
	$password = $_POST['password'];

	$sql="INSERT INTO child VALUES(NULL, '$name', '$age', '$username', '$password',$parent_id)";

	$result= mysqli_query($connection,$sql);
	if($result) {
		$msg[] = ['done'=>'true'];
	} else {
		$msg[] = ['done'=>'false'];
	}

	echo json_encode($msg);

?>