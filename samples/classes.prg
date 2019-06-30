function Main()

   local oInstance, cArgs := AP_Args(), cInfo := "", aInfo, n

   GetNew()
   TBrowseNew()
   HBDebugger()
   HBDbWindow()
   HbDbMenu()
   HbEditor()

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
               padding: 10px;
            }  

            .datas {
               padding: 10px;
            }  

            .methods {
               padding: 10px;
            }  
         </style>
      </head>
      
      <body>
         <div class="container-fluid">
            <div class="row">
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">CLASSES</div>
                  <div>
                  <?prg local n := 1
                        local cClasses := ""
                        
                        while ! Empty( __ClassName( n ) )
                           cClasses += '<a class="classes" onclick="GetInfo(' + "'" + __ClassName( n ) + "'" + ');">' + __ClassName( n++ ) + "</a><br>" + CRLF
                        end   
                        
                        return cClasses?>
                  </div>      
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavenderblush;">
                  <div class="header">DATAS</div>
                  <div id="datas"></div>
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">METHODS</div> 
                  <div id="methods"></div>
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
         </script>

         </body>
      </html>

   ENDTEXT

return nil

function Error()

return ErrorNew()

function Hash()

return {=>}

function Pointer()

return @Pointer()

