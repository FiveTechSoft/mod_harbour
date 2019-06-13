//----------------------------------------------------------------//

function Main()
   
   ? '<meta http-equiv="refresh" content="1"/>'
   
   ? "<h2>Reading the cookie</h2>"
   ?
   ? Time(), '<hr>'
   
   ? 'cookies: ', GetCookies()
    
return nil

//----------------------------------------------------------------//

function GetCookies()

   local hHeadersIn := AP_HeadersIn()
   
return If( hb_HHasKey( hHeadersIn, "Cookie" ), hb_hGet( hHeadersIn, "Cookie" ), "" )

//----------------------------------------------------------------//
