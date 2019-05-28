// Using the HeadersIn as a hash

#xcommand ? <cText> => AP_RPuts( <cText> + "<br>" )

function Main()

   local hHeadersIn := AP_HeadersIn()

   ? "Retrieving the Headers In 'Host': " 
   if hb_HHasKey( hHeadersIn, "Host" )
      ? hHeadersIn[ "Host" ]
   endif   

   ? "Retrieving the Headers In 'Cookie': "
   if hb_HHasKey( hHeadersIn, "Cookie" )
      ? hHeadersIn[ "Cookie" ]
   endif   

return nil
