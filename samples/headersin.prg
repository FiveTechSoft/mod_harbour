#xcommand ? <cText> => AP_RPuts( <cText> + "<br>" )

//----------------------------------------------------------------------------//

function Main()

   local n
   
   for n = 1 to AP_HeadersInCount()
      ? AP_HeadersInKey( n ) + " = " + AP_HeadersInVal( n ) + "<br>"
   next
   
return nil

//----------------------------------------------------------------------------//
