//----------------------------------------------------------------//

function Main()
   
   ? '<meta http-equiv="refresh" content="1"/>'
   
   ? Time(), '<hr>'
   
   ? 'MyCookie value: ', GetCookie( 'MyCookie' )
    
return nil

//----------------------------------------------------------------//

function GetCookie( cCookie )

   local hHeadersIn := AP_HeadersIn()
   
return If( hb_HHasKey( hHeadersIn, "Cookie" ), hb_hGet( hHeadersIn, "Cookie" ), "" )

//----------------------------------------------------------------//
