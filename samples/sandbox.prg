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
              style="background-color:#159957;background-image:linear-gradient(120deg, #155799, #159957);height:50px;">
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
               <li><button class="btn btn-success navbar-btn" onclick="Clear()"><span class="glyphicon glyphicon-edit"></span> Clear</button></li> 
               <div class="col-sm-2";>
               <input type="file" class="btn btn-success navbar-btn" name="SelectFile" id="selectfile" onchange="openFile(event)"><br>
               </div>
            </ul>
         </nav>
      </div>
      <div class="row">
         <div class="col-sm-1" style="background-color:silver;width:40px;height:650px;">
         </div>
         <div class="col-sm-5" style="background-color:silver;width:650px;">
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

            function Clear() {
               var text = '';
               editor.setValue( text );
            }
            function openFile(event) {
               var input = event.target;
               var reader = new FileReader();
               reader.readAsText( input.files[0] );
               reader.onload = function(){
               var text = reader.result;
               editor.setValue( text );
             }
           }
         </script>
 
         <div class="col-sm" id="result" style="background-color:silver;height:650px;">
         </div>
      </div>
   </body>
   </html>
   ENDTEXT

return nil
