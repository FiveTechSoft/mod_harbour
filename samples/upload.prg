function Main()

   local hPairs := AP_PostPairs()

   if Len( hPairs ) == 0
      ? "This example is used from samples/sendfile.prg"
   else
      MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/received.txt", ValToChar( hPairs ) )
   endif

return nil
