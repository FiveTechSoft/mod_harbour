function Main()

   local hPairs := AP_PostPairs()

   if Len( hPairs ) == 0
      ? "This example is used from samples/post.prg"
   else
      ? ValToChar( hPairs )
   endif

return nil
