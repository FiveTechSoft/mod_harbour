// #define REDIRECTION  302

function Main()

   ? AP_HeadersOutCount() 
   ? "<br>"

   // AP_HeadersOutSet( "Location", "test.prg" )

   // ? AP_HeadersOutCount()
   // ? "<br>"

   AP_HeadersOutSet( "Set-Cookie", "cookie-name=harbour;expires=" + DToS( Date() ) )
   
   ? AP_HeadersOutCount()
   ? "<br>"
   
   // ErrorLevel( REDIRECTION )

return nil
