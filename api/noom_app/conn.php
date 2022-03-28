<?php 
	global $connection;
	$connection = mysqli_connect('localhost','root','','noomDb') or die("Error while connect to server");

	mysqli_query($connection,"SET character_set_results = 'utf8'");
	mysqli_query($connection,"SET character_set_client = 'utf8'");
	mysqli_query($connection,"SET character_set_connection = 'utf8'");
	mysqli_query($connection,"SET character_set_database = 'utf8'");
	mysqli_query($connection,"SET character_set_server = 'utf8'");

?>

