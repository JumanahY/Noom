<?php
	require("conn.php");
	
	$msg = array();
	
	$child_id = $_POST['child_id'];
	$sql="DELETE FROM child  WHERE child_id={$child_id} ";
	$result= mysqli_query($connection,$sql);
	if($result) {
		$msg[] = ['done'=>'true'];
	} else {
		$msg[] = ['done'=>'false'];
	}

	echo json_encode($msg);
?>