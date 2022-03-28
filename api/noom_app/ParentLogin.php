<?php
	require("conn.php");
	
	$data = array();
	
	$username = $_POST['username'];
	$password = $_POST['password'];
	$sql="SELECT * FROM parent WHERE username='$username' and password='$password' LIMIT 1";
	////echo $sql;
	$result= mysqli_query($connection,$sql);
	while($row = mysqli_fetch_array($result)) {
		$data[] = $row;
	}

	echo json_encode($data);
?>