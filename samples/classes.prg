function Main()

   local oInstance, cArgs := AP_Args(), cDatas := "", aDatas, n

   if ! Empty( cArgs )
      if Left( cArgs, 6 ) == "datas:"
         oInstance = &( SubStr( cArgs, 7 ) + "()" )
         aDatas = __objGetMsgList( oInstance, .T. )
         for n = 1 to Len( aDatas )
            cDatas += "<a>" + aDatas[ n ] + "</a><br>" + CRLF
         next   
         ?? cDatas
         return nil
      endif
   endif   

   TEMPLATE
      <html lang="en">
      <head>
         <title>Panels</title>
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
         </style>
      </head>
      
      <body>
         <div class="container-fluid">
            <div class="row">
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">CLASSES</div>
                  <?prg local n := 1
                        local cClasses := ""
                        
                        while ! Empty( __ClassName( n ) )
                           cClasses += '<a class="classes" onclick="GetDatas(' + "'" + __ClassName( n ) + "'" + ');">' + __ClassName( n++ ) + "</a><br>" + CRLF
                        end   
                        
                        return cClasses?>
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavenderblush;">
                  <div class="header">DATAS</div>
                  <div id="datas"></div>
               </div>
               <div class="col-sm-2 panel-resizable" style="background-color:lavender;">
                  <div class="header">METHODS</div>    
               </div>
            </div>
            <div class="row">
               <div class="col-sm-6 panel-resizable" style="resize:both;background-color:lightsteelblue;height:400px;">
                  <div class="header">CODE</div>    
               </div>
            </div>
         </div>

         <script>
            function GetDatas( cClassName )
            {
               $.post( "classes.prg?datas:" + cClassName ).done( function( data ) { $( '#datas' ).html( data ); } )
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
