<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
       
	   <style>
	   
	    body{
    background:lightslategray;
  margin: 0;
  padding: 0;
  font-family: 'Tajawal', sans-serif;
}
    form {border: 3px solid lightslategray;}
    
    input[type=text], input[type=password] {
      width: 100%;
      padding: 12px 20px;
      margin: 8px 0;
      display: inline-block;
      border: 1px solid #ccc;
      box-sizing: border-box;
    }
    
    button {
      background-color: #4CAF50;
      color: white;
      padding: 14px 20px;
      margin: 8px 0;
      border: none;
      cursor: pointer;
      width: 100%;
    }
    
    button:hover {
      opacity: 0.8;
    }
    
    .cancelbtn {
      width: auto;
      padding: 10px 18px;
      background-color: #f44336;
    }
    
  
    
    .container {
      padding: 16px;
    }
    
    span.psw {
      float: right;
      padding-top: 16px;
    }
    
    /* Change styles for span and cancel button on extra small screens */
    @media screen and (max-width: 300px) {
      span.psw {
         display: block;
         float: none;
      }
      .cancelbtn {
         width: 100%;
      }
    }
           
.bx{
  background-color: lavenderblush; /* Black w/ opacity */
  border: 0.1px solid lightgrey;
  box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
  border-radius: 12px;
  height: 400px;
  margin: 30% auto auto auto;
  width: 50%;
  padding: 30px 2px;
}
button{ 
    height: 50px;
    margin: 50% 50% 50% 5%;
box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
  background-color: gray;
  border-radius: 12px;
  cursor: pointer;
   border:  5% sloid lightgray;
  text-align: center;
  text-decoration: none;
  font-size: 20px;
  padding: 10px 40px;

}
a{
    color: black;
    text-decoration: none;
}
.jbx {height: 80px;
    padding: 0px;
disply:block;
   margin: auto;
  width: 10%;
  
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}
button:hover {
  opacity: 0.8;
  background-color: transparent;
  
}
p,h2{
  padding: 70px 0;
  border: 3px;
  text-align: center;
  

nav ul {
  list-style-type: none;
  margin: 0;
  padding: 0 2% 0 30%;
  overflow: hidden;
  background-color: lightgrey;
}
nav ul li {
  float: left;
}
nav ul li a {
  display: block;
  color: white;
  text-align: center;
  padding: 17px 30px;
  text-decoration: none;
}
nav ul li a:hover{
  color: #d6d5e7;
  text-shadow: 0 1px 2px #cccc;
}
.logo{
  width: 100px;
}
.top{
  width: 100%;
  padding: 100px;
  display: inline-flex;
  background-color:lightslategray;
  position: fixed;
  z-index: 4;
}
nav{
  position: fixed;
  margin-top: 207px;
  width: 100%;
  z-index: 4;
}



.dropbtn {
  background-color: lightslategray;
  color: white;
  padding: 14px;
  font-size: 16px;
  border: none;
  cursor: pointer;
  border-radius: 40px;
  text-decoration: none;
}

.container {
  padding: 2px 16px;
}
.text-center{
  text-align: center;
}
.contacts{
  display: inline-flex;
}
.contacts img{
  width: 30px;
}
.path-nav{
  background-color: lightgray;
  margin-top: 20px;
}
.path-nav a{
  text-decoration: none;
  color: white;
  margin-right: 15px;
}


.big-text{
  color: #034670;
  font-weight: bolder;
}
.f-nav{
  color: #e4e2ef;
  padding: 0 10px 30px 10px;
}
.footernav a{
  text-decoration: none;
  display: inline-flex;
}

.center{
  text-align: center;
}
footer{
  background-color: lightslategrey;
  color: white;
  padding: 50px 0;
}
        
        
        </style>
    </head>
    <body><div class="top">
    <a href="hom.html">
        <img alt="" src="" class="logo">
    </a>
    <div class="joins">
      <div class="join-holder">
        <div class="dropdown">
          
        </div>
      </div>
    </div>
  </div>
  <nav>
    <ul>
      <li><a class="active" href="newhtml.html">Home</a></li>
      <li><a href="">xxx</a></li>
      <li><a href="">xxx</a></li>
      <li><a href="">xxx</a></li>
    </ul>
  <div class="container path-nav">
    <a href="newhtml.html">Home </a>
    
  </div></nav>
  <br>
  <div class="container" style="width: 100%;text-align: center;">
    <h1 class="big-text"> </h1>
  </div>
  
        
       <h2>Trainer Login Form</h2>

<form action="/action_page.php" method="post">
  

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>
        
    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>

  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form>
        
        <footer>
  <div class="container" style="display: inline-flex; width: 50%">
    <div class="footernav" style="width: 100%">
       <a href="">
        <p class="f-nav">lohin</p>
      </a>
      <a href="newhtml1.html">
        <p class="f-nav">Sing up</p>
      </a>
    
        </a><a href="">
        <p class="f-nav">inf</p>
        </a><a href="">
        <p class="f-nav">xx</p>
      </a>
    </div>
  </div>

  <br>
  <br>
 
  <p class="center">Office 1, Building 34, SA<br>
      ourweb@gmail.com<br>
      92005555 <br>Copy Right ©</p>
</footer>
    </body>
</html>
