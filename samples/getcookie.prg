//----------------------------------------------------------------//

function Main()
   
   ? '<meta http-equiv="refresh" content="1"/>'
   
   ? "<h2>Reading the cookies</h2>"
   ?
   ? Time(), '<hr>'
   
   ? 'cookies: ', ValToChr( GetCookies() )
    
return nil

//----------------------------------------------------------------//

function GetCookies()

   local hHeadersIn := AP_HeadersIn()
   local cCookies := If( hb_HHasKey( hHeadersIn, "Cookie" ), hb_hGet( hHeadersIn, "Cookie" ), "" )
   local aCookies := hb_aTokens( cCookies, ";" )
   local cCookie
   local hCookies := {=>}
   
   for each cCookie in aCookies
      hb_HSet( SubStr( cCookie, 1, At( "=", cCookie ) - 1 ),;
               SubStr( cCookie, At( "=", cCookie ) + 1 ) )
   next            
   
return hCookies

//----------------------------------------------------------------//
