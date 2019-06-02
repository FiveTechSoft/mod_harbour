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
      <a class="navbar-brand" onclick="$('#about').modal()">Pulldown</a>
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
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Project
        <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#">Index</a></li>
          <li><a href="#">Search</a></li>
          <li class="divider"></li>
          <li><a href="#">About...</a></li>
        </ul>
      </li>
      <form class="navbar-form navbar-left" action="">
        <div class="input-group">
          <input type="text" class="form-control" placeholder="Search">
          <div class="input-group-btn">
            <button class="btn btn-default" type="submit">
              <i class="glyphicon glyphicon-search"></i>
            </button>
          </div>
        </div>
      </form>
    </ul>
    <ul class="nav navbar-nav navbar-right">
      <li><a href="#"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
      <li><a onclick="$('#login').modal()"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
    </ul>
  </div>
</nav>
</div>
</html>

ENDTEXT

return nil
