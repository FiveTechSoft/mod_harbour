function Main()

   local cCode := "null"
   local cArgs := mh_Query()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/data/forms.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/data/forms.dbf",; 
                { { "ID",   "C", 20, 0 },;
                  { "CODE", "M", 10, 0 } } )
   endif

   if mh_Method() == "POST"
      USE ( hb_GetEnv( "PRGPATH" ) + "/data/forms.dbf" ) 
      APPEND BLANK
      field->Id = DToS( Date() ) + StrTran( Time(), ":", "" )
      field->code = mh_Body()
      ?? field->Id
      USE
      return nil 
   endif

   if ! Empty( cArgs )
      if "&" $ cArgs
         cArgs = SubStr( cArgs, 1, At( "&", cArgs ) - 1 )
      endif   
      USE ( hb_GetEnv( "PRGPATH" ) + "/data/forms.dbf" ) SHARED NEW
      LOCATE FOR cArgs $ Field->Id
      if Found()
         cCode = field->code
      endif
      USE
   endif         

   BLOCKS PARAMS cCode
      <html>
      <head>
         <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.0/css/all.css'>
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
         <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
         <link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/themes/base/jquery-ui.css"/>   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
         <script src="https://github.com/FiveTechSoft/mod_harbour/blob/master/javascript/jquery.touch.min.js"></script>
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
            width:127px;
            height:293px;
            position:absolute;  
         }
         .inspector{
            box-shadow:10px 10px 10px darkgray, 0px 0px 10px darkgray;
            top:150px;
            left:1400px;
            width:250px;
            height:362px;
            position:absolute; 
            background: lightgray; 
            border-radius: 5px;
         }         
         .form {
            border: solid gray 1px;
            width: 800px;
            height: 600px;
            left:450px;
            position: absolute;
            overflow: hidden;
            background: whitesmoke url('https://github.com/FiveTechSoft/mod_harbour/blob/master/samples/images/grid_20.png?raw=true') repeat;
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
         .listbox {
            border: 3px solid;
            border-color: darkgray white white darkgray;
            width: 170px;
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
         .checkbox {
            border: 0px solid;
            border-color: white darkgray darkgray white;
            width: 180px;
            height: 45px;
            overflow: hidden;
            -webkit-user-modify: read-write;
         }
         .image {
            border: 1px solid;
            width: 120px;
            height: 100px;
            overflow: hidden;
            background-image: url( "https://raw.githubusercontent.com/FiveTechSoft/mod_harbour/master/samples/images/fivetech.bmp" );
            background-repeat: no-repeat;
            background-size: 100% 100%;
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
            width:40px;
            height:40px;
            -webkit-user-modify:read-only;
            border: 0px solid;
            border-radius: 2px;
         }
         .toolbar:hover{
            background-color: darkgray;  
         }
         .table_inspector {
            width:880px;
            border: 1px solid black;
            border-collapse: collapse;
         }
         .table_inspector th {
            padding:4px;
            border: 1px solid black;
            background-color:white;
            border-radius: 5px;
         }
         .table_inspector tr {
            padding:4px;
         }
         .table_inspector td {
            border: 1px solid black;
            width:50%;
            padding-left:0px;         
         }
         .table_inspector .left {
            border: 1px solid black;
            width:50%;
            padding-left:10px;         
         }
      </style>   
      </head>
      <body>
         <h1>mod_harbour forms designer</h1>
         <br><br>
         <div id="toolbox" class="toolbox">
            <table style="border-spacing:0px;">
            <tr>
            <td><div class="button toolbar" title="label" onclick="AddLabel()"><i class="fas fa-font" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="input" onclick="AddEdit()"><i class="fas fa-edit" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="button" onclick="AddButton()"><i class="fas fa-square" style="color:black;font-size:20px;padding:10px;"></i></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="combobox/listbox" onclick="AddListbox()"><i class="fas fa-bars" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="radios"><i class="fas fa-list-ul" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="image" onclick="AddImage()"><i class="far fa-image" style="color:black;font-size:20px;padding:10px;"></i></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="checkbox" onclick="AddCheckbox()"><i class="far fa-check-square" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar"></div></td>
            <td><div class="button toolbar"></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar"></div></td>
            <td><div class="button toolbar"></div></td>
            <td><div class="button toolbar"></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar" title="fine move to top" onclick="ToUp()"><i class="fas fa-arrow-up" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="fine move to bottom" onclick="ToDown()"><i class="fas fa-arrow-down" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar"></div></td>        
            </tr>
            <tr>
            <td><div class="button toolbar" title="fine move to left" onclick="ToLeft()"><i class="fas fa-arrow-left" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="fine move to right" onclick="ToRight()"><i class="fas fa-arrow-right" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="delete" onclick="Remove()"><i class="fas fa-times" style="color:black;font-size:20px;padding:10px;"></i></div></td>         
            </tr>
            <tr>
            <td><div class="button toolbar"><i class="" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="save" onclick="AsJson()"><i class="fas fa-cloud-upload-alt" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            <td><div class="button toolbar" title="settings"><i class="fas fa-cog" style="color:black;font-size:20px;padding:10px;"></i></div></td>
            </tr>
            </table> 
         </div>
         <div id="form" class="form">
            <div class="ui-resizable-handle ui-resizable-se segrip main"></div>
         </div>
         <div id="inspector" class="inspector">
            <table class="table_inspector" style="width:100%">
               <tr>
                  <th>Property</th>
                  <th>Value</th>
               </tr>
               <tr>
                  <td class="left">top</td>
                  <td><input id="top" type="text" value="0" style="padding:2px"></td>
               </tr>
               <tr>
                  <td class="left">left</td>
                  <td><input id="left" type="text" value="0" style="padding:2px"></td>
               </tr>
               <tr>
                  <td class="left">width</td>
                  <td><input id="width" type="text" value="0" style="padding:2px"></td>
               </tr>
               <tr>
                  <td class="left">height</td>
                  <td><input id="height" type="text" value="0" style="padding:2px"></td>
               </tr>
               <tr>
                  <td class="left">prompt</td>
                  <td><input id="prompt" type="text" value="..." style="padding:0px;padding-right:2px;width:100%">
                  <button style="position:absolute;background-color:lightgray;top:136;width:18px;right:3px;height:18;padding:2px;padding-bottom:3px;"></button></td>
               </tr>
               <tr>
                  <td class="left">color</td>
                  <td><input id="color" type="color" value="#000000" style="width:100px;padding:2px"></td>
               </tr>
               <tr>
                  <td class="left">bgcolor</td>
                  <td><input id="bgcolor" type="color" value="#000000" style="width:100px;padding:2px"></td>
               </tr>
            </table>
         </div>
         <script>
            var labels = 0;
            var edits = 0;
            var buttons = 0;
            var checkboxes = 0;
            var images = 0;
            var listboxes = 0;
            var oCtrl;
            var oForm = JSON.parse( '{{cCode}}' ); 

            $( "#form" ).resizable( {
               handles: { 'se': '.segrip' } } ).draggable( { drag: function() {
                  $( "#top" ).val( $(this).css( "top" ) ); 
                  $( "#left" ).val( $(this).css( "left" ) ); } } );

            $( "#form" ).focus(function() { oCtrl = $(this);
                                            $( "#top" ).val( $(this).css( "top" ) ); 
                                            $( "#left" ).val( $(this).css( "left" ) );
                                            $( "#width" ).val( $(this).css( "width" ) );
                                            $( "#height" ).val( $(this).css( "height" ) );
                                            $( "#prompt").val( "" );
                                            $( "#color" ).val( RGBToHex( $(this).css( "color" ) ) ); 
                                            $( "#bgcolor" ).val( RGBToHex( $(this).css( "backgroundColor" ) ) ); } );
            $( document ).ready( function(){ $( "#form" ).focus(); $( "#form" ).focus(); } );
            $( "#form" ).resize( function(){ $( "#form" ).focus(); } );  
            $( "#color" ).on( "input", function(e){ oCtrl.css( "color", $( "#color" ).val() ) } );
            $( "#bgcolor" ).on( "input", function(e){ oCtrl.css( "backgroundColor", $( "#bgcolor" ).val() ) } );

            if( oForm != null )
            {
               $( "#form" ).css( "top",  oForm.top );
               $( "#form" ).css( "left", oForm.left );
               $( "#form" ).css( "width", oForm.width );
               $( "#form" ).css( "height", oForm.height );
               $( "#form" ).css( "backgroundColor", oForm.bgcolor );

               if( oForm.controls.length > 0 )
               {
                  for( var n = 0; n < oForm.controls.length; n++ )
                  {
                     var ctrl; 

                     if( oForm.controls[ n ].class.includes( "label" ) )
                        ctrl = AddLabel();

                     if( oForm.controls[ n ].class.includes( "button" ) )
                        ctrl = AddButton();

                     if( oForm.controls[ n ].class.includes( "edit" ) )
                        ctrl = AddEdit();

                     if( oForm.controls[ n ].class.includes( "checkbox" ) )
                        ctrl = AddCheckbox();

                     if( oForm.controls[ n ].class.includes( "listbox" ) )
                        ctrl = AddListbox();
   
                     if( oForm.controls[ n ].class.includes( "image" ) )
                        ctrl = AddImage();
                           
                     ctrl.css( "top", oForm.controls[ n ].top );
                     ctrl.css( "left", oForm.controls[ n ].left );
                     ctrl.css( "width", oForm.controls[ n ].width );
                     ctrl.css( "height", oForm.controls[ n ].height );
                     ctrl.find( "#label" ).html( oForm.controls[ n ].prompt );
                     ctrl.css( "color", oForm.controls[ n ].color );
                     ctrl.css( "backgroundColor", oForm.controls[ n ].bgcolor );
                  }   
               }   
            }   

            $( "#toolbox" ).draggable();
            $( "#inspector" ).draggable();  

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
               '<label onclick="$(this).parent().focus()"><font id="label" size="5">Label' + 
               labels + '</font></label>' +
               '</div>';

               $( "#form" ).append( cHtml );
               InitGrips( cId );
               return $( "#" + cId ); 
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

               $( "#form" ).append( cHtml );
               $( "#" + cId ).position().top += 2;
               InitGrips( cId );
               return $( "#" + cId ); 
            }  

            function AddListbox()
            { 
               var cId = "lbx" + ++listboxes;
               var cHtml = 
               '<div id="' + cId + '" class="listbox">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' +
               '<i class="fas fa-angle-down" onclick="$(this).parent().focus()"' + 
               'style="height:10px;color:black;background:lightgray;font-size:20px;padding:10px;right:-5px;float:right;"></i>' + 
               '</div>';

               $( "#form" ).append( cHtml );
               $( "#" + cId ).position().top += 2;
               InitGrips( cId );
               return $( "#" + cId );
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
               '<font id="label" size="5">Button' + buttons + '</font></label>' +
               '</div>';

               $( "#form" ).append( cHtml );
               InitGrips( cId );
               return $( "#" + cId ); 
            }
            
            function AddCheckbox()
            { 
               var cId = "chk" + ++checkboxes;
               var cHtml = 
               '<div id="' + cId + '" class="checkbox">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' + 
               '<label onclick="$(this).parent().focus()" style="padding:12px;">' +
               '<i class="far fa-check-square" style="color:black;font-size:20px;padding:10px;"></i>' +
               '<font id="label" size="5">Checkbox' + checkboxes + '</font></label>' +
               '</div>';

               $( "#form" ).append( cHtml );
               InitGrips( cId );
               return $( "#" + cId );
            }

            function AddImage()
            { 
               var cId = "img" + ++images;
               var cHtml = 
               '<div id="' + cId + '" class="image">' + 
               '<div class="ui-resizable-handle ui-resizable-nw nwgrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-ne negrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-sw swgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-se segrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-n ngrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-s sgrip"></div>' +
               '<div class="ui-resizable-handle ui-resizable-e egrip"></div>' + 
               '<div class="ui-resizable-handle ui-resizable-w wgrip"></div>' + 
               '</div>';

               $( "#form" ).append( cHtml );
               $( "#" + cId ).position().top += 2;
               InitGrips( cId );
               return $( "#" + cId );
            } 

            function InitGrips( cId )
            {    
               $( "#"  + cId ).resizable({
                  resize: function() { $( "#width" ).val( $(this).css( "width" ) );
                                       $( "#height" ).val( $(this).css( "height" ) ); },
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
               }).draggable( { drag: function() {
                  $( "#top" ).val( $(this).css( "top" ) ); 
                  $( "#left" ).val( $(this).css( "left" ) ); }, grid: [20, 20],
               axis: "x,y",
               containment: '#form' } );

               $( "#" + cId ).focus( function() { $(this).find(".ui-resizable-handle").css( "visibility", "visible"),
                   $( "#top" ).val( $(this).css( "top" ) ); $( "#left" ).val( $(this).css( "left" ) );
                   $( "#width" ).val( $(this).css( "width" ) ); $( "#height" ).val( $(this).css( "height" ) );
                   $( "#prompt" ).val( $(this).find( "#label" ).html() );
                   $( "#color" ).val( RGBToHex( $(this).css( "color" ) ) ); 
                   $( "#bgcolor" ).val( RGBToHex( $(this).css( "backgroundColor" ) ) ); } );
               $( "#" + cId ).resize( function(){ $( "#width" ).val( $(this).css( "width" ) ); } );     
               $( "#" + cId ).focusout( function() { oCtrl = $(this); $(this).find(".ui-resizable-handle").css( "visibility", "hidden") } ); 

               $( "#prompt" ).keydown( function(e){ if( e.which == 13 ) oCtrl.find( "#label" ).html( $( "#prompt" ).val() ); } );
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

            function Remove()
            {
               if( oCtrl.hasClass( "label" ) )
                  labels--;
               if( oCtrl.hasClass( "edit" ) )
                  edits--;                  
               if( oCtrl.hasClass( "button" ) )
                  buttons--;
               if( oCtrl.hasClass( "checkbox" ) )
                  checkboxes--;                  
               if( oCtrl.hasClass( "image" ) )
                  images--;    
               if( oCtrl.hasClass( "listbox" ) )
                  listboxes--;    
   
               oCtrl.remove();
            }

            function RGBToHex(rgb) 
            {
               var sep = rgb.indexOf(",") > -1 ? "," : " ";
               rgb = rgb.substr(4).split(")")[0].split(sep);
             
               var r = (+rgb[0]).toString(16),
                   g = (+rgb[1]).toString(16),
                   b = (+rgb[2]).toString(16);
             
               if (r.length == 1)
                 r = "0" + r;
               if (g.length == 1)
                 g = "0" + g;
               if (b.length == 1)
                 b = "0" + b;
             
               return "#" + r + g + b;
             }

            function AsJson()
            {
               var o = { top: $( "#form" ).css( "top" ),
                         left: $( "#form" ).css( "left" ),
                         width: $( "#form" ).css( "width" ),
                         height: $( "#form" ).css( "height" ),
                         bgcolor: RGBToHex( $( "#form" ).css( "backgroundColor" ) ),
                         controls: [] };

               var controls = $( "#form" ).children();
               
               for( var n = 1; n < controls.length; n++ )
               {
                  var ctrl = { class: $( controls[ n ] ).attr( "class" ),
                               top: $( controls[ n ] ).css( "top" ),
                               left: $( controls[ n ] ).css( "left" ),
                               width: $( controls[ n ] ).css( "width" ),
                               prompt: $( controls[ n ] ).find( "#label" ).html(),
                               color: RGBToHex( $( controls[ n ] ).css( "color" ) ),
                               bgcolor: RGBToHex( $( controls[ n ] ).css( "backgroundColor" ) ) };
                  o.controls.push( ctrl );             
               }   

               $.post( "designer.prg", JSON.stringify( o ) )
                  .done( function( data ) { console.log( 'DONE', data ); location.href="designer.prg?" + data; } )
                  .fail( function( data ) { console.log( 'ERROR', data ); } );         
            }   
         </script>
      </body>
   ENDTEXT

return nil   
