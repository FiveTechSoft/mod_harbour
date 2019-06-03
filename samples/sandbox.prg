function Main()

   TEMPLATE
   <html>
   <head>
      <title>Sandbox</title>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
      <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
   </head>
   <body>
      <div class="container-fluid">
         <nav class="navbar navbar-inverse" 
              style="background-color:#159957;background-image:linear-gradient(120deg, #155799, #159957);">
            <div class="navbar-header">
               <a class="navbar-brand" href="https://fivetechsoft.github.io/mod_harbour/"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
               <a class="navbar-brand" onclick="MsgInfo( 'run your tests here' )">mod_harbour sandbox</a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
            </div>
            <ul class="nav navbar-nav">
               <li><button class="btn btn-success navbar-btn" onclick="Run()"><span class="glyphicon glyphicon-flash"></span> Run</button></li> 
            </ul>
         </nav>
      </div>

      <div class="row">
         <div class="col-sm-1" style="background-color:silver;height:650px;">
         </div>
         <div class="col-sm-5">
            <div id="editor">function Main()
 
   ? "Hello world"
    
return nil </div>
         </div>

         <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
         <script>
            var editor = ace.edit("editor");
            editor.setTheme("ace/theme/pastel_on_dark");
            editor.setFontSize(18);     
            editor.setHighlightActiveLine(true);
            editor.session.setMode("ace/mode/c_cpp");
         </script>
 
         <div class="col-sm" id="result" style="background-color:silver;height:650px;">
         </div>
      </div>
   </body>
   </html>
   ENDTEXT

return nil
