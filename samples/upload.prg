function Main()

   local hPairs := AP_PostPairs()

   if Len( hPairs ) == 0
      ? "This example is used from samples/sendfile.prg"
   else
      if HB_HHasKey( hPairs, "filename" )
         MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/" + hPairs[ "filename" ],;
                   hb_UrlDecode( hPairs[ "data" ] ) )
         MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/received.txt",;
                   MemoRead( hb_GetEnv( "PRGPATH" ) + "/data/received.txt" ) + CRLF + ;
                   hPairs[ "filename" ] )
      endif                        
   endif

return nil
