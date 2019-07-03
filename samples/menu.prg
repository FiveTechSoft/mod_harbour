function Main()

   local cTitle := "MyApp"
   local aMenuItems := { { "Tables", { "Customers", "Invoices", "Stock" } },;
                         { "Invoices", { "Browse", "Print" } },;
                         { "Reports", { "Clients", "Invoices", "Stock" } },;
                         { "Help", { "Index", "Search", "-", "About" } } }

   TEMPLATE PARAMS cTitle, aMenuItems
<html lang="en">
<head>
  <title><?prg return cTitle ?></title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
  <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
</head>

<body>

<div class="container-fluid" style="overflow:hidden;">
  
   <nav class="navbar navbar-inverse">
      <div class="navbar-header">
         <a class="navbar-brand"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
         <a class="navbar-brand" onclick="MsgInfo( 'my mod_harbour app', 'Information' )" style="cursor:pointer;"><?prg return cTitle ?></a>
         <a class="navbar-brand"></a>
         <a class="navbar-brand"></a>
         <a class="navbar-brand"></a>
         <a class="navbar-brand"></a>
         <a class="navbar-brand"></a>
      </div>
      <ul class="nav navbar-nav">
         <?prg local n, m, cItems := ""
       
             for n = 1 to Len( aMenuItems )
                cItems += '<li class="dropdown">'
                cItems += '   <a class="dropdown-toggle" data-toggle="dropdown" style="cursor:pointer;">' + aMenuItems[ n ][ 1 ]
                cItems += '   <span class="caret"></span></a>'
                cItems += '   <ul class="dropdown-menu">'
                for m = 1 to Len( aMenuItems[ n ][ 2 ] )
                   if aMenuItems[ n ][ 2 ][ m ] == "-"
                      cItems += '      <li class="divider"></li>'
                   else   
                      cItems += '      <li><a onclick="MsgInfo(' + "'" + aMenuItems[ n ][ 2 ][ m ] + "'" + ;
                                ')" style="cursor:pointer;">' + aMenuItems[ n ][ 2 ][ m ] + "</a></li>"
                   endif   
                next
                cItems += '   </ul>'
                cItems += '</li>'
             next   
             return cItems ?>
      </ul>         
      <ul class="nav navbar-nav navbar-right">
         <li><a><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
         <li><a onclick='MsgGet( "username:", "Please identify" );' style="cursor:pointer;"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
      </ul>
   </nav>

   <div class="row" style="margin-right:0px">
      <div class="col-sm-2">
         <nav class="navbar navbar-expand-lg navbar-inverse">
            <a class="navbar-brand">Dashboard</a>
         </nav> 
         <ul style="background-color:silver;height:89%;margin-bottom:0px;">
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
            <a class="navbar-brand">Main</a>
         </nav> 
      </div>
   </div>
</div>

<body>
</body>

</html>

ENDTEXT

return nil