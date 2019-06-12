//----------------------------------------------------------------//

function Main()
	
   ? "<h2>Creating a cookie</h2>"
   ?
   ? 'Current date and time: ', hb_datetime(), '<hr>'

   SetCookie( 'MyCookieName', 'This cookie was created at ' + Time() + ;
              '. In this example it only lives 60 seconds...', 60 )
	
   ? 'cookie created!'
   ?
   ? '<button type="button" onclick="location.href=' + "'getcookie.prg'" + '">get cookie</button>'

return nil

//----------------------------------------------------------------//

function SetCookie( cName, cValue, nSecs, cPath, cDomain, lHttps, lOnlyHttp ) 

   local cCookie := ''
	
   // check parameters
   hb_default( @cName, '' )
   hb_default( @cValue, '' )
   hb_default( @nSecs, 3600 )   // Session will expire in Seconds 60 * 60 = 3600
   hb_default( @cPath, '/' )
   hb_default( @cDomain	, '' )
   hb_default( @lHttps, .F. )
   hb_default( @lOnlyHttp, .F. )	
	
   // we build the cookie
   cCookie += cName + '=' + cValue + ';'
   cCookie += 'expires=' + CookieExpire( nSecs ) + ';'
   cCookie += 'path=' + cPath + ';'
   cCookie += 'domain=' + cDomain + ';'
		
   // pending logical values for https y OnlyHttp

   // we send the cookie
   AP_HeadersOutSet( "Set-Cookie", cCookie )

return nil

//----------------------------------------------------------------//
// CookieExpire( nSecs ) builds the time format for the cookie
// Using this model: 'Sun, 09 Jun 2019 16:14:00'

function CookieExpire( nSecs )

   local tNow := hb_datetime()	
   local tExpire   // TimeStampp 
   local cExpire   // TimeStamp to String
	
   hb_default( @nSecs, 60 ) // 60 seconds for this test
   
   tExpire = hb_ntot( ( hb_tton( tNow ) * 86400 - hb_utcoffset() + nSecs ) / 86400 )

   cExpire = cdow( tExpire ) + ', ' 
	     cExpire += AllTrim( Str( Day( hb_TtoD( tExpire ) ) ) ) + ;
	     ' ' + cMonth( tExpire ) + ' ' + AllTrim( Str( Year( hb_TtoD( tExpire ) ) ) ) + ' ' 
   cExpire += AllTrim( Str( hb_Hour( tExpire ) ) ) + ':' + AllTrim( Str( hb_Minute( tExpire ) ) ) + ;
              ':' + AllTrim( Str( hb_Sec( tExpire ) ) )

return cExpire

//----------------------------------------------------------------//
