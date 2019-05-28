// Using the HeadersIn as a hash

#xcommand ? <cText> => AP_RPuts( <cText> + "<br>" )

function Main()

   local hHeadersIn := AP_HeadersIn()

   ? "Retrieving the Headers In 'Host': " 
   ? hHeadersIn[ "Host" ]

   ? "Retrieving the Headers In 'Cookie': "
   ? hHeadersIn[ "Cookie" ]

return nil
