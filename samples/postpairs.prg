function Main()

   local n
   
   if AP_PostPairsCount() == 0
      ? "This example is used from samples/post.prg"
   endif   
   
   for n = 0 to AP_PostPairsCount() - 1
      ? AP_PostPairsKey( n ) + " = " + AP_PostPairsVal( n )
   next
   
return nil
