function Main()

   TEMPLATE
      <html>
      <head>
         <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.0/css/all.css'>
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
         <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
         <link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/themes/base/jquery-ui.css"/>   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
      <style>
         body {
            background: #bdc3c7; 
            background: -webkit-linear-gradient(to left, lightgray, darkgray);  
            background: linear-gradient(to left, whitesmoke, royalblue);             
         }
         .toolbox{
            box-shadow:10px 10px 10px darkgray, 0px 0px 10px darkgray;
            top:150px;
            left:150px;
            width:157px;
            height:310px;
            position:absolute;  
         }
         #container {
            border: solid gray 1px;
            width: 800px;
            height: 400px;
            position: absolute;
            overflow: hidden;
            background: whitesmoke url('https://s3.amazonaws.com/com.appgrinders.test/images/grid_20.png') repeat;
            box-shadow:10px 10px 10px darkgray, 0px 0px 10px darkgray;
            border-radius:10px;
         }
         .label {
            border: 0px solid;
            border-color: black;
            width: 80px;
            height: 30px;
            overflow: hidden;
            -webkit-user-modify: read-write;
         }
         .edit {
            border: 3px solid;
            border-color: darkgray white white darkgray;
            width: 300px;
            height: 32px;
            overflow: hidden;
            background-color: whitesmoke;
            -webkit-user-modify: read-write;
         }         
         .button {
            border: 3px solid;
            border-color: white darkgray darkgray white;
            width: 117px;
            height: 32px;
            overflow: hidden;
            background-color: lightgray;
            -webkit-user-modify: read-write;
         }
         .nwgrip, .negrip, .swgrip, .segrip, .ngrip, .egrip, .sgrip, .wgrip {
            width: 7px;
            height: 11px;
            background-color: #000000;
            border: 1px solid #000000;
            visibility:hidden;
         } 
         .segrip.main{
            visibility:visible;            
         }    
         .nwgrip {
            left: -5px;
            top: -5px;
            width: 11px;
         }
         .negrip{
            top: -5px;
            right: -5px;
            width: 11px;
         }
         .swgrip{
            bottom: -5px;
            left: -5px;
            width: 11px;
         }
         .segrip{
            bottom: -5px;
            right:-5px;
            width: 11px;
         }
         .ngrip{
            top: -5px;
            left:50%;
         }
         .sgrip{
            bottom: -5px;
            left: 50%;
         }
         .wgrip{
            left:-5px;
            top:47%;
            width: 11px;
            height: 7px;
         }
         .egrip{
            right:-5px;
            top:47%;
            width: 11px;
            height: 7px;     
         }
         .toolbar{
            width:50px;
            height:50px;
            -webkit-user-modify:read-only;
            border: 0px solid;
            border-radius: 5px;
         }

         .toolbar:hover{
            background-color: darkgray;  
         }
      </style>   
      </head>
      <body>
         <h1>mod_harbour forms designer</h1>
         <br><br>
         <div id="toolbox" class="toolbox">
            <table style="border-spacing:0px;">
            <tr>
            <td><div class="button toolbar" title="label" onclick="AddLabel()"><i class="fas fa-font" style="color:black;font-size:20px;padding:17px;"></i></div></td>
            <td><div class="button toolbar" title="input" onclick="AddEdit()"><i class="fas fa-edit" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="button" onclick="AddButton()"><i class="fas fa-square" style="color:black;font-size:20px;padding:15px;"></i></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="combobox"><i class="fas fa-bars" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="radios"><i class="fas fa-list-ul" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="image"><i class="far fa-image" style="color:black;font-size:20px;padding:15px;"></i></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="checkbox"><i class="far fa-check-square" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar"></div></td>
            <td><div class="button toolbar"></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="fine move to top" onclick="ToUp()"><i class="fas fa-arrow-up" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="fine move to bottom" onclick="ToDown()"><i class="fas fa-arrow-down" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar"></div></td>        
            </tr>
            <tr>
            <td><div class="button toolbar" title="fine move to left" onclick="ToLeft()"><i class="fas fa-arrow-left" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="fine move to right" onclick="ToRight()"><i class="fas fa-arrow-right" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar"></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="snap to grid" onclick="SnapToGrid()"><i class="fas fa-compress" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="save"><i class="fas fa-cloud-upload-alt" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            <td><div class="button toolbar" title="settings"><i class="fas fa-cog" style="color:black;font-size:20px;padding:15px;"></i></div></td>
            </tr>
            </table> 
         </div>
         <div id="container" style="top:140px;left:400px;width:1000px;height:600px;">
            <div class="ui-resizable-handle ui-resizable-se segrip main"></div>
         </div>
         <script>
            var labels = 0;
            var edits = 0;
            var buttons = 0;
            var oCtrl;

            $( "#container" ).resizable( {
               handles: { 'se': '.segrip' } } ).draggable();

            $( "#toolbox" ).draggable();

            function AddLabel()
            { 
               var cId = "lbl" + ++labels;
               var cHtml = 
               '<div id="' + cId + '" class="label">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' + 
               '<label onclick="$(this).parent().focus()"><font size="5">Label' + 
               labels + '</font></label>' +
               '</div>';

               $( "#container" ).append( cHtml );
               InitButtons( cId );
            }  

            function AddEdit()
            { 
               var cId = "inp" + ++edits;
               var cHtml = 
               '<div id="' + cId + '" class="edit">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' + 
               '</div>';

               $( "#container" ).append( cHtml );
               $( "#" + cId ).position().top += 2;
               InitButtons( cId );
            }  

            function AddButton()
            { 
               var cId = "btn" + ++buttons;
               var cHtml = 
               '<div id="' + cId + '" class="button" style="width:100px">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' + 
               '<label onclick="$(this).parent().focus()" style="padding:12px;">' +
               '<font size="5">Button' + buttons + '</font></label>' +
               '</div>';

               $( "#container" ).append( cHtml );
               InitButtons( cId );
            }
            
            function InitButtons( cId )
            {    
               $( "#"  + cId ).resizable({
                  handles: {
                     'nw': '.nwgrip',
                     'ne': '.negrip',
                     'sw': '.swgrip',
                     'se': '.segrip',
                     'n': '.ngrip',
                     'e': '.egrip',
                     's': '.sgrip',
                     'w': '.wgrip'
                  }
               }).draggable( { grid: [20, 20],
               axis: "x,y",
               containment: '#container' } );

               $( "#" + cId ).focus(function() { $(this).find(".ui-resizable-handle").css( "visibility", "visible") } ); 
               $( "#" + cId ).focusout(function() { oCtrl = $(this); $(this).find(".ui-resizable-handle").css( "visibility", "hidden") } ); 
            }      

            function ToUp()
            {
               oCtrl[0].style.top = parseFloat( oCtrl[0].style.top ) - 1;
            }   

            function ToDown()
            {
               oCtrl[0].style.top = parseFloat( oCtrl[0].style.top ) + 1;
            }   

            function ToLeft()
            {
               oCtrl[0].style.left = parseFloat( oCtrl[0].style.left ) - 1;
            }   

            function ToRight()
            {
               oCtrl[0].style.left = parseFloat( oCtrl[0].style.left ) + 1;
            }   
   
            function SnapToGrid()
            {
               oCtrl[0].style.top = parseInt( oCtrl[0].style.top ) + 10 + "px";
               console.log( parseInt( oCtrl[0].style.top ) % 20 );
               oCtrl.position().left -= oCtrl.position().left % 20;
            }   
         </script>
      </body>
   ENDTEXT

return nil   