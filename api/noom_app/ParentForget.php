<?php
	require("conn.php");
	
	$data = array();
	
	$username = $_POST['username'];
	$sql="SELECT * FROM parent WHERE username='$username' LIMIT 1";
	////echo $sql;
	$result= mysqli_query($connection,$sql);
    $num = mysqli_num_rows($result);
    if($num == 1) {
        $row = mysqli_fetch_array($result);
        $password = $row['password'];

		$data[] = $row;
         $msg = "Your Password For You : $username is <b>:  $password </b>";

        $send = mail($row['email'],"Password Recover",$msg);
        
        echo json_encode($data);
    } else {
        echo json_encode($data);
    }
?>