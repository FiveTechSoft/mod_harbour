function Main()

   local hPairs := AP_PostPairs()
   local cData, cFileName, nStart, cBytes 

   if Len( hPairs ) == 0
      ? "This example is used from samples/sendfile.prg"
   else
      cData = HB_HValueAt( hPairs, 1 )
      cFileName = SubStr( cData, 2, At( ";", cData ) - 3 )
      hb_MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName,;
                   cBytes := HB_BASE64DECODE( SubStr( cData, nStart := At( "base64,", cData ) + 7,;
                   At( "------", cData ) - nStart ) ) )
      ?? hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName + " ready!" + "<br>" + ;
         "File " + If( File( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName ), "exists", " didn't arrived" )          
   endif

return nil
