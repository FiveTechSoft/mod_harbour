function Main()

TEMPLATE
<html lang="en">
<head>
  <title>modHarbour menu</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
</head>

<body>
<div class="container-fluid">
  
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
      <a class="navbar-brand" onclick="$('#about').modal()">MyApp</a>
      <a class="navbar-brand" href="#"></a>
      <a class="navbar-brand" href="#"></a>
      <a class="navbar-brand" href="#"></a>
      <a class="navbar-brand" href="#"></a>
      <a class="navbar-brand" href="#"></a>
    </div>
    <ul class="nav navbar-nav">
      <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">File
        <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#">New</a></li>
          <li><a onclick="$('#openfile').modal()">Open</a></li>
          <li><a onclick="SendFile()">Save</a></li>
          <li class="divider"></li>
          <li><a href="#">Close</a></li>
        </ul>
      </li>
      <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Edit
        <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a onclick="document.execCommand('cut')">Cut</a></li>
          <li><a onclick="document.execCommand('copy')">Copy</a></li>
          <li><a onclick="document.execCommand('paste')">Paste</a></li>
        </ul>
      </li>
      <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Project
        <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#">Open</a></li>
          <li><a href="#">Save</a></li>
          <li><a href="#">Close</a></li>
          <li class="divider"></li>
          <li><a href="#">Add item</a></li>
          <li><a href="#">Remove item</a></li>
        </ul>
      </li>
      <li class="help">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Help
        <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#">Index</a></li>
          <li><a href="#">Search</a></li>
          <li class="divider"></li>
          <li><a href="#">About...</a></li>
        </ul>
      </li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
      <li><a href="#"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
      <li><a onclick="$('#login').modal()"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
    </ul>
  </div>
</nav>
</div>

  <div class="row">
    <div class="col-sm-2">
       <nav class="navbar navbar-expand-lg navbar-inverse">
          <a class="navbar-brand" href="#">Dashboard</a>
       </nav> 
        <ul style="background-color:silver;height:800px">
         <li>Clients
           <ul>                                
             <li style="color:white;">New</li>
             <li style="color:white;">Edit</li>
             <li style="color:white;">Delete</li>
           </ul>
         </li>
         <li>Invoices
           <ul>                                
             <li style="color:white;">New</li>
             <li style="color:white;">Edit</li>
             <li style="color:white;">Delete</li>
           </ul>
         </li>                                
       </ul>        
    </div>
    <div class="col-sm-10">
       <nav class="navbar navbar-expand-lg navbar-inverse">
          <a class="navbar-brand" href="#">Main</a>
       </nav> 
    </div>
  </div>

<body>
</html>

ENDTEXT

return nil
