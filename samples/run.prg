#define REDIRECTION  302

function Main()

   local n
   
   AP_HeadersOutSet( "Access-Control-Allow-Origin", "*" )
   AP_HeadersOutSet( "Location", "run.prg" )
   
   for n = 0 to AP_PostPairsCount() - 1
      ? AP_PostPairsKey( n ) + " = " + AP_PostPairsVal( n )
   next
   
   ErrorLevel( REDIRECTION )

return nil
