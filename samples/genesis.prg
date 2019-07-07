function Main()

   TEMPLATE
<html>

<head>
  <title>Genesis</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 

  <style>
      .vertical-menu a {
      background-color: rgb(34, 45, 50);
      color: gray;
      display: block;
      padding: 20px;
      padding-left: 30px;
      text-decoration: none;
      border-style: solid;
      border-width:1px;
      border-color: gray black black black;
      cursor: pointer;
      }

      .vertical-menu a.active {
      background-color: gainsboro;
      color: {{GetColor()}};
      }   

      .vertical-menu a:hover {
         background-color: black;
         color: white;
      }

   </style>
</head>

<body>

   <div class="container-fluid" style="overflow:hidden;">
      <div class="row" style="margin-right:0px">
         <div id="leftmenu" class="col-sm-2">
            <nav class="navbar navbar-expand-lg navbar-inverse" style="background-color:rgb(96, 82, 140);border:0px;">
               <a class="navbar-brand" style="color:white;cursor:pointer;padding-left:50px;">Gen<font color="silver">esis</font></a>
            </nav> 
            <div style="background-color:rgb(34, 45, 50);height:94%;">
               <div class="vertical-menu" style="background-color:rgb(34, 45, 50);height:500px;">
                  <a onclick="SelectCategory( this, 'home' );">
                     <span class="glyphicon glyphicon-home" style="color: silver; padding-right: 15px;"></span>Home</a>
                  <a onclick="SelectCategory( this, 'router' );">
                     <span class="glyphicon glyphicon-random" style="color: silver; padding-right: 15px;"></span>Router</a>
                     <a onclick="SelectCategory( this, 'menu' );">
                     <span class="glyphicon glyphicon-th-list" style="color: silver; padding-right: 15px;"></span>Menu</a>
                  <a onclick="SelectCategory( this, 'views' );">
                     <span class="glyphicon glyphicon-eye-open" style="color: silver; padding-right: 15px;"></span>Views</a>
                  <a onclick="SelectCategory( this, 'controller' );">
                     <span class="glyphicon glyphicon-list-alt" style="color: silver; padding-right: 15px;"></span>Controllers</a>
                  <a onclick="SelectCategory( this, 'users' );">
                     <span class="glyphicon glyphicon-user" style="color: silver; padding-right: 15px;"></span>Users</a>
                  <a onclick="SelectCategory( this, 'settings' );">
                     <span class="glyphicon glyphicon-cog" style="color: silver; padding-right: 15px;"></span>Settings</a>
               </div>
            </div>
         </div>
         <div class="col-sm-10">
            <nav class="navbar navbar-expand-lg navbar-inverse" style="background-color:rgb(96, 92, 170);border:0px;">
               <a style="cursor:pointer;" onclick="$( '#leftmenu' ).width( 75 );" class="navbar-brand"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
               <a class="navbar-brand" style="color:white;">Main</a>
            </nav> 
            <div style="background-color:#ecf0f5;height:94%;">
            </div>
         </div>
      </div>
   </div>
</body>

</html>

ENDTEXT

return nil   