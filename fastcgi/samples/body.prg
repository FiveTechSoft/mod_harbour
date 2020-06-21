// Use the postman utility to send different body values

function Main()

   if Empty( AP_Body() )
      ? "Use the postman utility to send different body values"
   else   
      AP_RPuts( AP_Body() )
   endif   
   
return nil   
