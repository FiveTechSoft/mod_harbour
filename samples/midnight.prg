// {% hb_SetEnv( "HB_USER_PRGFLAGS", "-B" ) %}

function Main()

   local cArgs := AP_Args(), cLeftPath := "/", cRightPath := "/", cName

   // ShowConsole()
   // AltD()
   // AltD( 1 )

   if Left( cArgs, Len( "left:" ) ) == "left:"
      cName = SubStr( cArgs, At( ":", cArgs ) + 1 )
      cLeftPath = cName
      if ! File( cName )
         ? GetFiles( cName, "true" )
      endif   
      return nil
   endif  

   if Left( cArgs, Len( "right:" ) ) == "right:"
      cName = SubStr( cArgs, At( ":", cArgs ) + 1 )
      cRightPath = cName
      if ! File( cName )
         ? GetFiles( cName, "false" )
      endif   
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
     function GetFiles( cName, lLeft )
     {
        var cId;
        
        if( lLeft )
           cId = "#leftpath";
        else
           cId= "#rightpath";
     
        if( cName == ".." )
        {
           cName = $( cId ).html();
           cName = cName.substr( 0, cName.lastIndexOf( "/" ) );
           if( cName.length == 0 )
              cName = "/";
        }
        else
        {
           if( $( cId ).html().length == 1 )
              cName = $( cId ).html() + cName;
           else
              cName = $( cId ).html() + "/" + cName;
        }      
           
        $( cId ).html( cName );        
        
        if( lLeft )
           $.post( "midnight.prg?left:" + cName ).done( function( data ) { 
                  $( '#left' ).html( data ); } )
        else          
           $.post( "midnight.prg?right:" + cName ).done( function( data ) { 
                  $( '#right' ).html( data ); } )
     }
     </script>

     <body>
        <div class="container-fluid">
           <div class="row">
              <div class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div id="leftpath" class="header"><?prg return cLeftPath ?></div>
                 <div id="left" style="overflow-y: scroll;height:85%">
                    <?prg return GetFiles( "", "true" ) ?>
                 </div>
              </div>   
              <div class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div id="rightpath" class="header"><?prg return cRightPath ?></div>
                 <div id="right" style="overflow-y: scroll;height:85%">
                    <?prg return GetFiles( "", "false" ) ?>
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

function GetFiles( cName, cLeftOrRight )

   local aFiles := Directory( cName + If( Right( cName, 1 ) == "/", "*", "/*" ), "DH" )
   local cFiles := "", n
   
   ASort( aFiles, nil, nil, { | x, y | Upper( x[ 1 ] ) < Upper( y[ 1 ] ) } )
   
   for n = 1 to Len( aFiles )
      if ! aFiles[ n ][ 1 ] == "."
         cFiles += '<a onclick="GetFiles( ' + "'" + aFiles[ n ][ 1 ] + "'" + ', ' + cLeftOrRight + ' );" >' + aFiles[ n ][ 1 ] + "</a><br>"
      endif   
   next
   
return cFiles