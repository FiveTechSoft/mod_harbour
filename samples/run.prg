function Main()

   local n
   
   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )
   
   for n = 0 to AP_PostPairsCount() - 1
      ? AP_PostPairsKey( n ) + " = " + AP_PostPairsVal( n )
   next

return nil
