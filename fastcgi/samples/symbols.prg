function Main()

  local lAll     := ( AP_Args() == "all" .or. Empty( AP_Args() ) .or. ! AP_Args() $ "code;noncode" )
  local lCode    := ( AP_Args() == "code" )
  local lNonCode := ( AP_Args() == "noncode" )
  local n
  
  TEMPLATE PARAMS lAll, lCode, lNonCode
     <html>
     <head> 
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <style>
            .btn-secondary {
               border-color: gainsboro;
               background-color: turquoise;
               color: white;
            }

            .btn:active {
               background-color: lightcyan;
            }

            .active {
               background-color: white;
               color: black;
            }
        </style>
     </head>

     <body style="background-color:dodgerblue;">
        <div class="container-fluid">
           <h2 style="color:white">mod_harbour > The Virtual Machine > The Global Symbol Table</h2><hr>           
           <div class="btn-group btn-group-toggle" data-toggle="buttons">
              <a class="btn btn-secondary <?prg return If( lAll, "active", "" )?>" onclick="location.href='symbols.prg?all'"><input type="radio" autocomplete="off">All Symbols</a>
              <a class="btn btn-secondary <?prg return If( lCode, "active", "" )?>" onclick="location.href='symbols.prg?code'"><input type="radio" autocomplete="off">With code</a>
              <a class="btn btn-secondary <?prg return If( lNonCode, "active", "" )?>" onclick="location.href='symbols.prg?noncode'"><input type="radio" autocomplete="off">Datas / Methods / other</a>
           </div><hr>
  ENDTEXT 

  for n = __DynsCount() to 1 step -1
     if lAll .or. lCode 
        if __DynsIsFun( n )
           ?? '<p style="color:springgreen;">' + AllTrim( Str( __DynsCount() - n + 1 ) ) + ". " + __DynsGetName( n ) + "</p>" + CRLF
        endif
     endif
     if lAll .or. lNonCode
        if ! __DynsIsFun( n )
           ?? '<p style="color:yellow;">' + AllTrim( Str( __DynsCount() - n + 1 ) ) + ". " + __DynsGetName( n ) + "</p>" + CRLF
        endif
     endif
  next

  ?? "</div>" 
  ?? "</body>"
  ?? "</html>"

return nil
