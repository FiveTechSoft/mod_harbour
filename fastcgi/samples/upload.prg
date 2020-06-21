function Main()

   local hPairs := AP_PostPairs()
   local cData, cFileName, nStart 

   if Len( hPairs ) == 0
      ? "This example is used from samples/sendfile.prg"
   else
      cData = HB_HValueAt( hPairs, 1 )
      cFileName = SubStr( cData, 2, At( ";", cData ) - 3 )
      hb_MemoWrit( hb_GetEnv( "PRGPATH" ) + "/data/" + cFileName,;
                   HB_BASE64DECODE( SubStr( cData, nStart := At( "base64,", cData ) + 7,;
                   At( "------", cData ) - nStart ) ) )
   endif

return nil
