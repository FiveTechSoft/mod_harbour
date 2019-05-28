// Using the HeadersIn as a hash

#xcommand ? <cText> => AP_RPuts( <cText> + "<br>" )

function Main()

   local hHeadersIn := AP_HeadersIn()

   ? "Retrieving the HeadersIn 'Host': " 
   if hb_HHasKey( hHeadersIn, "Host" )
      ? hHeadersIn[ "Host" ]
   endif   

   ? "Retrieving the HeadersIn 'Cookie': "
   if hb_HHasKey( hHeadersIn, "Cookie" )
      ? hHeadersIn[ "Cookie" ]
   endif   

return nil
