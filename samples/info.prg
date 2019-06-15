//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

function Info()

   local cI    := ' '
   local n     := 0
   local aDefs := { ;
      ' HB_VERSION_HARBOUR        ',;
      ' HB_VERSION_COMPILER       ',;
      ' HB_VERSION_MAJOR          ',;
      ' HB_VERSION_MINOR          ',;
      ' HB_VERSION_RELEASE        ',;
      ' HB_VERSION_STATUS         ',;
      ' HB_VERSION_REVISION       ',;
      ' HB_VERSION_CHANGELOG_LAST ',;
      ' HB_VERSION_CHANGELOG_ID   ',;
      ' HB_VERSION_PCODE_VER      ',;
      ' HB_VERSION_PCODE_VER_STR  ',;
      ' HB_VERSION_BUILD_DATE_STR ',;
      ' HB_VERSION_BUILD_DATE     ',;
      ' HB_VERSION_BUILD_TIME     ',;
      ' HB_VERSION_BUILD_PLAT     ',;
      ' HB_VERSION_BUILD_COMP     ',;
      ' HB_VERSION_FLAG_PRG       ',;
      ' HB_VERSION_FLAG_C         ',;
      ' HB_VERSION_FLAG_LINKER    ',;
      ' HB_VERSION_BITWIDTH       ',;
      ' HB_VERSION_ENDIANNESS     ',;
      ' HB_VERSION_MT             ',;
      ' HB_VERSION_SHARED         ',;
      ' HB_VERSION_UNIX_COMPAT    ',;
      ' HB_VERSION_PLATFORM       ',;
      ' HB_VERSION_CPU            ',;
      ' HB_VERSION_COMPILER_CPP   ',;
      ' HB_VERSION_MAX_           ' }

   ?? '<h1>Info</h1>' + CRLF
   ?? '<h3>Platform</h3>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   ?? '<tr><td><b>OS</b></td><td>' + OS() + '</td></tr>' + CRLF
   ?? '<tr><td><b>Harbour</b></td><td>' + Version() + '</td></tr>' + CRLF
   ?? '<tr><td><b>Build date</b></td><td>' + hb_BuildDate() + '</td></tr>' + CRLF
   ?? '<tr><td><b>Compiler</b></td><td>' + hb_Compiler() + '</td></tr>' + CRLF
   ?? '</table>'  + CRLF
   ?? '<h3>Capabilities</h3>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   cI := ""
   AEval( rddList(), {| X | cI += iif( Empty( cI ), '', ', ' ) + X } )
   ?? '<tr><td><b>RDD</b></td><td>' + cI + '</td></tr>' + CRLF
   ?? '</table>' + CRLF
   ?? '<h3>Version Harbour</h3>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   FOR n := 0 TO 27
      cI := ""
      if Valtype( hb_Version( n ) ) = 'N'
         cI  := Str( hb_Version( n ) )
      else
         if Valtype( hb_Version( n ) ) = 'D'
            cI  := DTos( hb_Version( n ) )
         else
            if Valtype( hb_Version( n ) ) = 'L'
               cI  := if( hb_Version( n ), 'true', 'false' )
            else
               cI  := hb_Version( n )
            endif
         endif
      endif
      ?? '<tr><td>' + StrZero( n, 2 ) + '</td><td><b>' + aDefs[ n + 1 ] + '</b></td><td>' + cI + '</td></tr>' + CRLF
   NEXT   
   ?? '</table>' + CRLF

return nil

//----------------------------------------------------------------------------//
