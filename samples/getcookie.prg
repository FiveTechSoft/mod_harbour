//----------------------------------------------------------------//

function Main()
   
   ? Time(), '[F5] to refresh page...', '<hr>'
   
   ? 'MyCookie value: ', GetCookie( 'MyCookie' )
    
return nil

//----------------------------------------------------------------//

function GetCookie( cCookie )

   local nLen := AP_HeadersInCount() - 1 
   local uVal := ''
   local n, nJ, cKey, cPart
    
   for n = 0 to nLen
      cKey = AP_HeadersInKey( n )
      uValue = AP_HeadersInVal( n )             
        
      if Lower( cKey ) == 'cookie'
         for each cPart IN hb_ATokens( uValue, ";" )                       
            if ( nJ := At( "=", cPart ) ) > 0
               if ! Empty( cKey := AllTrim( Left( cPart, nJ - 1 ) ) )
                  if cKey == cCookie 
                     uVal = AllTrim( SubStr( cPart, nJ + 1 ) )
                     EXIT
                  endif
               endif
            else // Empty Cookie
               if ! Empty( cKey := AllTrim( Left( cPart, nJ - 1 ) ) )  
                  if cKey == cCookie 
                     uVal = AllTrim( SubStr( cPart, nJ + 1 ) )
                     EXIT
                  endif
               endif
            endif
         next
      endif
   next   
        
return uVal

//----------------------------------------------------------------//
