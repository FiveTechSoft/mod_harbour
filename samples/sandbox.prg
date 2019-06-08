function Main()

   TEMPLATE
   <html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, shrink-to-fit=no">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
      <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
      <title>Sandbox</title>
   </head>
   <body>
      <div class="container-fluid">
         <nav class="navbar navbar-inverse" 
              style="background-color:#159957;background-image:linear-gradient(120deg, #155799, #159957);height:8%;">
            <div class="navbar-header">
               <a class="navbar-brand" href="https://fivetechsoft.github.io/mod_harbour/"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
               <a class="navbar-brand" onclick="MsgInfo( 'run your tests here' )">mod_harbour sandbox</a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
            </div>
            <ul class="nav navbar-nav">
               <li><button class="btn btn-success navbar-btn" onclick="Run()"><span class="glyphicon glyphicon-flash"></span> Run</button></li> 
               <div class="col-sm-1";>
               <button class="btn btn-success navbar-btn" onclick="Clear()"><span class="glyphicon glyphicon-edit"></span> Clear</button>
               </div>
               <a class="navbar-brand" href="#"></a>
               <div class="col-sm-1";>
               <button class="btn btn-success navbar-btn" onclick="Download()"><span class="glyphicon glyphicon-save"></span> Save</button>
               </div>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <div class="col-sm-2";>
               <input type="file" class="btn btn-success navbar-btn" name="SelectFile" id="selectfile" accept=".prg" onchange="openFile(event)"><br>
               </div>
            </ul>
         </nav>
      </div>
         <ul class="nav nav-tabs" id="tabs">
            <li class="active" id="tab1"><a href="#row1">Noname</a></li>
         </ul>
      <div class="row" id="row1" style="background-color:silver;width:101.0%;height:82.5%;">
         <div class="col-sm-1" style="background-color:silver;width:1.50%;height:99.5%;"></div>
         <div class="col-sm-6" style="background-color:silver;height:99.5%;">
         <div id="editor" style="height:100%;">function Main()

   ? "Hello world"

return nil</div>
         </div>
         <div class="col-sm-1" style="background-color:silver;width:0.5%;height:99.5%;"></div>
         <div class="col-sm" id="result" style="background-color:LightYellow;width:99.6%;height:99.5%;"></div>
      </div>
         <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
         <script>
            var editor = ace.edit("editor");
            editor.setTheme("ace/theme/pastel_on_dark");
            editor.setFontSize(16);     
            editor.setHighlightActiveLine(true);
            editor.session.setMode("ace/mode/c_cpp");

            function Download(filename) {
               var filename = $('#tabs a:last').text();
               var content = editor.getValue();
               var pom = document.createElement('a');
               pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(content));
               pom.setAttribute('download', filename);

               if (document.createEvent) {
                   var event = document.createEvent('MouseEvents');
                   event.initEvent('click', true, true);
                   pom.dispatchEvent(event);
               }
               else {
                   pom.click();
               }
            }

            function Clear() {
               var text = '';
               editor.setValue( text );
               Run();
               selectfile.value = '';
            }

            function openFile(event) {
               var input = event.target;
               var reader = new FileReader();
               reader.readAsText( input.files[0] );
               reader.onload = function(){
               var text = reader.result;
               editor.setValue( text );
             }
               //addtab();
               $('#tabs a:last').text( input.files[0].name );
           }

           function addtab() {
             	var nextTab = $('#tabs li').size()+1;
             	// create the tab
             	//$('<li><a href="#tab'+nextTab+'" data-toggle="tab">Tab '+nextTab+'</a></li>').appendTo('#tabs');
               $('<li><a href="#row1"'+'" data-toggle="tab">Tab '+nextTab+'</a></li>').appendTo('#tabs');
             	// create the tab content
             	$('<div class="tab-pane" id="tab'+nextTab+'">tab' +nextTab+' content</div>').appendTo('.tab-content');
             	// make the new tab active
             	$('#tabs a:last').tab('show');
           }

         </script>
   </body>
   </html>
   ENDTEXT

return nil
