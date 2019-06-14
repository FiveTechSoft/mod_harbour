//----------------------------------------------------------------------------//

function Info()

   local cI  := " "
   local n   := 0

   ?? '<h1>Info</h1>' + CRLF
   ?? '<h2>Platform</h2>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   ?? '<tr><td>OS</td><td>' + FHtmlEncode( OS() ) + '</td></tr>' + CRLF
   ?? '<tr><td>Harbour</td><td>' + FHtmlEncode( Version() ) + '</td></tr>' + CRLF
   ?? '<tr><td>Build date</td><td>' + FHtmlEncode( hb_BuildDate() ) + '</td></tr>' + CRLF
   ?? '<tr><td>Compiler</td><td>' + FHtmlEncode( hb_Compiler() ) + '</td></tr>' + CRLF
   ?? '</table>'  + CRLF
   ?? '<h2>Capabilities</h2>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   cI := ""
   AEval( rddList(), {| X | cI += iif( Empty( cI ), "", ", " ) + X } )
   ?? '<tr><td>RDD</td><td>' + FHtmlEncode( cI ) + '</td></tr>' + CRLF
   ?? '</table>' + CRLF
   ?? '<h2>Version Harbour</h2>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   FOR n := 0 TO 27
      cI := ""
      if Valtype( hb_Version( n ) ) = "N"
         cI  := Str( hb_Version( n ) )
      else
         if Valtype( hb_Version( n ) ) = "D"
            cI  := DTos( hb_Version( n ) )
         else
            if Valtype( hb_Version( n ) ) = "L"
               cI  := if( hb_Version( n ), ".T.", ".F." )
            else
               cI  := hb_Version( n )
            endif
         endif
      endif
      ?? '<tr><td>' + Str( n ) + '</td><td>' + cI + '</td></tr>' + CRLF
   NEXT   
   ?? '</table>' + CRLF

return nil

//----------------------------------------------------------------------------//

function FHtmlEncode( cString )

  local nI, cI, cRet := ""

  for nI := 1 to Len( cString )
     cI := SubStr( cString, nI, 1 )
     if cI == "<"
        cRet += "&lt;"
     elseif cI == ">"
        cRet += "&gt;"
     elseif cI == "&"
        cRet += "&amp;"
     elseif cI == '"'
        cRet += "&quot;"
     else
        cRet += cI
     endif
  next nI

return cRet

//----------------------------------------------------------------------------//
