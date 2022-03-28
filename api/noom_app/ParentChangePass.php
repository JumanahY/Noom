<?php
	require("conn.php");
	
	$msg = array();
	
	$pass1 = $_POST['pass1'];
	$parent_id = $_POST['parent_id'];
	$sql="UPDATE parent SET password='$pass1' WHERE parent_id={$parent_id} ";
	$result= mysqli_query($connection,$sql);
	if($result) {
		$msg[] = ['done'=>'true'];
	} else {
		$msg[] = ['done'=>'false'];
	}

	echo json_encode($msg);
?>