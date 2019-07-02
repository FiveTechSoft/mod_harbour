function Main()

  TEMPLATE
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

     <body>
        <div class="container-fluid">
           <div class="row">
              <div id="left" class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div class="header">/</div>
                 <div style="overflow-y: scroll;height:85%">
                 <?prg local aFiles := Directory( "/*", "DH" )
                       local cFiles := ""

                       for n = 1 to Len( aFiles )
                          cFiles += "<a>" + aFiles[ n ][ 1 ] + "</a><br>"
                       next

                       return cFiles?>
                 </div>
              </div>
              <div id="right" class="col-sm-6 panel-resizable" style="overflow:hidden;background-color:lavender;">
                 <div class="header">"/"</div>
                 <div style="overflow-y: scroll;height:85%">
                 <?prg local aFiles := Directory( "/*", "DH" )
                       local cFiles := ""

                       for n = 1 to Len( aFiles )
                          cFiles += "<a>" + aFiles[ n ][ 1 ] + "</a><br>"
                       next

                       return cFiles?>
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
