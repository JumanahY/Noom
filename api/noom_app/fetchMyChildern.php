<?php
	require("conn.php");
    $parent_id = $_GET['parent_id'];
	$data = array();
	 $sql="SELECT * FROM child WHERE parent_id={$parent_id}";
	$result= mysqli_query($connection,$sql);
	while($row = mysqli_fetch_array($result)) {
		$data[] = $row;
	}

	echo json_encode($data);
?>