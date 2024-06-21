procedure main()
   
	local hCookies 	:= ap_cookieReadAll()
	local hKey 		:= nil 
	
	? '<hr>'	
	? 'ap_cookieReadAll(): Lee todas las cookies'
	
	for each hKey in hCookies	
		? hKey:__ENUMKEY(), " => ", hKey:__ENUMVALUE()	
	next 

	? '<hr>'	
	? "ap_getEnv( 'HTTP_COOKIE' ): ",  ap_getEnv( "HTTP_COOKIE" )
	? '<hr>'	
	? "ap_cookieReadAll(): ", ap_cookieReadAll()
	? '<hr>'	
	? 'ap_cookieRead( "MyCookieName" ) => ', ap_cookieRead( "MyCookieName" )
	? 'ap_cookieRead( "MyCookieSession" ) => ', ap_cookieRead( "MyCookieSession" )
	? '<hr>'	
	
return 
