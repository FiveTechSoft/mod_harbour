function Main()
   
   local hHeadersIn := AP_HeadersIn()

   ? Time(), '[F5] to refresh page...', '<hr>'
   
   ? 'Value MyCookie: ' , GetCookie( 'MyCookie' )
    
return nil

// Included in session.prg

function GetCookie( cCookie )
    LOCAL nLen  := AP_HeadersInCount() - 1 
    LOCAl uVal      := ''
    LOCAL n, nJ, cKey, cPart
    FOR n = 0 to nLen
    
        cKey    := AP_HeadersInKey( n )
        uValue  := AP_HeadersInVal( n )             
        
        IF ( lower(cKey) == 'cookie' )
        
            FOR EACH cPart IN hb_ATokens( uValue, ";" )                       
                IF ( nJ := At( "=", cPart ) ) > 0
                
                    IF ( !empty( cKey := Alltrim(Left( cPart, nJ - 1 )) ) )
                    
                        IF cKey == cCookie 
                            uVal := Alltrim(SubStr( cPart, nJ + 1 ))
                            EXIT
                        ENDIF
                        
                    ENDIF
                    
                ELSE    //  Empty Cookie
            
                    IF ( !empty( cKey := Alltrim(Left( cPart, nJ - 1 ))) )  
                    
                        IF cKey == cCookie 
                            uVal := Alltrim(SubStr( cPart, nJ + 1 ))
                            EXIT
                        ENDIF
                        
                    ENDIF
                    
                ENDIF
           
            NEXT        
        
        ENDIF       
        
    NEXT
    
RETU uVal
