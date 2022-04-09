<?php
	require("conn.php");
	
	$data = array();
	
	$username = $_POST['username'];
	$sql="SELECT * FROM child WHERE username='$username' LIMIT 1";
	////echo $sql;
	$result= mysqli_query($connection,$sql);
    $num = mysqli_num_rows($result);
    if($num == 1) {
        $row = mysqli_fetch_array($result);
        $password = $row['password'];
        $parent_id = $row['parent_id'];
        
        $sql2="SELECT * FROM parent WHERE parent_id='$parent_id' LIMIT 1";
        ////echo $sql;
        $result2= mysqli_query($connection,$sql2);
        $row2 = mysqli_fetch_array($result2);
         $password = $row2['password'];
		$data[] = $row;
         $msg = "The Password For Child : $username is <b>:  $password </b>";

        $send = mail($row2['email'],"Password Recover",$msg);
        
        echo json_encode($data);
    } else {
        echo json_encode($data);
    }
?>