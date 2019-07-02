function Main()

   local cArgs := AP_Args(), cLeftPath := "/", cRightPath := "/", cName
   
   if Left( cArgs, Len( "right:" ) ) == "right:"
      cName = SubStr( cArgs, At( ":", cArgs ) + 1 ) + "/"
      cRightPath = "/" + cName
      ? GetRight( cName )
      return nil
   endif   

   if Left( cArgs, Len( "left:" ) ) == "left:"
      cName = SubStr( cArgs, At( ":", cArgs ) + 1 ) + "/"
      cLeftPath = "/" + cName
      ? GetLeft( cName )
      return nil
   endif   

   TEMPLATE PARAMS cLeftPath, cRightPath
     <html lang="en">
     <head>
        <title>Midnight Commander</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
     </head>

     <style>
       a {
          font-family:Verdana;
          font-size: 22px;
          cursor: pointer; 
       }
     </style>
     
     <script>
     function GetLeft( cName )
     {
        $.post( "midnight.prg?left:" + cName ).done( function( data ) { 
                  $( '#left' ).html( data ); } )
     }

     function GetRight( cName )
     {
        $.post( "midnight.prg?right:" + cName ).done( function( data ) { 
                  $( '#right' ).html( data ); } )
     }
     </script>

     <body>
        <div class="container-fluid">
           <div class="row">
              <div class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div class="header"><?prg return cLeftPath ?></div>
                 <div id="left" style="overflow-y: scroll;height:85%">
                    <?prg return GetLeft( "" ) ?>
                 </div>
              </div>   
              <div class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div class="header"><?prg return cRightPath ?></div>
                 <div id="right" style="overflow-y: scroll;height:85%">
                    <?prg return GetRight( "" ) ?>
                 </div>
              </div>
           </div>
           <div class="row">
              <div class="col-sm-12 panel-resizable" style="resize:both;background-color:lightsteelblue;height:100px;">
                 <div class="header">powered by mod_harbour</div>
              </div>
           </div>
        </div>
     </body>
  ENDTEXT

return nil

function GetLeft( cName )

   local aFiles := Directory( "/" + cName + "*", "DH" )
   local cFiles := "", n
   
   for n = 1 to Len( aFiles )
      cFiles += '<a onclick="GetLeft( ' + "'" + aFiles[ n ][ 1 ] + "'" + ');" >' + aFiles[ n ][ 1 ] + "</a><br>"
   next
   
return cFiles

function GetRight( cName )

   local aFiles := Directory( "/" + cName + "*", "DH" )
   local cFiles := "", n
   
   for n = 1 to Len( aFiles )
      cFiles += '<a onclick="GetRight( ' + "'" + aFiles[ n ][ 1 ] + "'" + ');" >' + aFiles[ n ][ 1 ] + "</a><br>"
   next
   
return cFiles
