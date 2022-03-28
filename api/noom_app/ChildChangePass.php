<?php
	require("conn.php");
	
	$msg = array();
	
	$pass1 = $_POST['pass1'];
	$child_id = $_POST['child_id'];
	$sql="UPDATE child SET password='$pass1' WHERE child_id={$child_id} ";
	$result= mysqli_query($connection,$sql);
	if($result) {
		$msg[] = ['done'=>'true'];
	} else {
		$msg[] = ['done'=>'false'];
	}

	echo json_encode($msg);
?>