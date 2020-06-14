/*
**  cookies.prg -- cookies management
**
** Developed by Carles Aubia carles9000@gmail.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

//----------------------------------------------------------------//

function GetCookies()

   local cCookies := MH_GetEnv( "HTTP_COOKIE" )
   local aCookies := hb_aTokens( cCookies, ";" )
   local cCookie, hCookies := {=>}
   local cCookieHeader

   for each cCookie in aCookies
      hb_HSet( hCookies, LTrim( SubStr( cCookie, 1, At( "=", cCookie ) - 1 ) ),;
               SubStr( cCookie, At( "=", cCookie ) + 1 ) )
   next   
   
 return hCookies

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
   cCookie += 'expires=' + CookieExpires( nSecs ) + ';'
   cCookie += 'path=' + cPath + ';'
   
   if ! Empty( cDomain )
      cCookie += 'domain=' + cDomain + ';'
   endif
		
   // pending logical values for https y OnlyHttp

   // we send the cookie
   mh_Header( "Set-Cookie: " + cCookie )

return nil

//----------------------------------------------------------------//
// CookieExpire( nSecs ) builds the time format for the cookie
// Using this model: 'Sun, 09 Jun 2019 16:14:00'

function CookieExpires( nSecs )

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
