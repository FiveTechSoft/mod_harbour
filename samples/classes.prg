function Main()

   local oInstance, cArgs := AP_Args(), cInfo := "", aInfo, n

   GetNew()
   TBrowseNew()
   HBDebugger()
   HBDbWindow()
   HbDbMenu()
   HbEditor()
   HbDbArray()
   HBDbHash()
   HBDbInput()
   HBDbMenuItem()
   HBDbObject()
   HBBrwText()
   HBMemoEditor()
   HBPersistent()
   Symbol()
   HBReportForm()

   if ! Empty( cArgs ) .and. Len( cArgs ) < 15
      oInstance = &( cArgs + "()" )
      aInfo = __objGetMsgList( oInstance, .T. )
      for n = 1 to Len( aInfo )
         cInfo += '<a class="datas">' + aInfo[ n ] + "</a><br>" + CRLF
      next
      cInfo += ";"
      aInfo = __objGetMsgList( oInstance, .F. )
      for n = 1 to Len( aInfo )
         cInfo += '<a class="methods">' + aInfo[ n ] + "</a><br>" + CRLF
      next   
      ?? cInfo
      return nil
   endif   

   TEMPLATE
      <html lang="en">
      <head>
         <title>Classes</title>
         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
         <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
         
         <style>
            .panel-resizable {
               resize: horizontal;
               overflow: auto;
               height: 300px;
               padding: 0px;
               border: 1px;
               border-color: gainsboro;
               border-style: solid;
            }

            .header {
               background-color:gainsboro;
               padding: 7px;
            }

            .classes {
               cursor: pointer;
               display: block;
               padding-left: 10px;
            }  

            .classes:hover {
               color: blue;
            }  

           .active {
               color: white;
               background-color: blue;
            }

           .active:hover {
               color: yellow;
            }

            .datas {
               padding: 10px;
               cursor: pointer;
            }  

            .methods {
               padding: 10px;
               cursor: pointer;
            }  
         </style>
      </head>
      
      <body>
         <div class="container-fluid">
            <div class="row">
               <div class="col-sm-2 panel-resizable" style="overflow:hidden;background-color:lavender;">
                  <div class="header">CLASSES</div>
                  <div style="overflow-y: scroll;height:85%">
                  <?prg local n := 1
                        local cClasses := ""
                        
                        while ! Empty( __ClassName( n ) )
                           cClasses += '<a class="classes" onclick="toggleColor( this );' + ;
                                       'GetInfo(' + "'" + __ClassName( n ) + "'" + ');">' + __ClassName( n++ ) + "</a>" + CRLF
                        end   
                        
                        return cClasses?>
                  </div>      
               </div>
               <div class="col-sm-2 panel-resizable" style="overflow:hidden;background-color:lavenderblush;">
                  <div class="header">DATAS</div>
                  <div id="datas" style="overflow-y: scroll;height:85%"></div>
               </div>
               <div class="col-sm-2 panel-resizable" style="overflow:hidden;background-color:lavender;">
                  <div class="header">METHODS</div> 
                  <div id="methods" scrolling="auto" style="overflow-y: scroll;height:85%"></div>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-6 panel-resizable" style="resize:both;background-color:lightsteelblue;height:400px;">
                  <div class="header">CODE</div>    
               </div>
            </div>
         </div>

         <script>
            function GetInfo( cClassName )
            {
               $.post( "classes.prg?" + cClassName ).done( function( data ) { 
                  $( '#datas' ).html( data.substring( 0, data.indexOf( ";" ) - 1 ) ); 
                  $( '#methods' ).html( data.substring( data.indexOf( ";" ) + 1 ) );                   
               } )
            }
            
            function toggleColor( o )
            {
               $( o ).addClass( "active" );
               $( o ).siblings().removeClass( "active" );
            }   
         </script>

         </body>
      </html>

   ENDTEXT

return nil

function Error()

return ErrorNew()

function Hash()

return __HBHash()

function Pointer()

return __HBPointer()

function ScalarObject()

return HBScalar()
