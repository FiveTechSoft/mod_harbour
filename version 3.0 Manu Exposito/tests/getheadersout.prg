procedure main()

	local hHeaders, hKey

	ap_setHeaderOut( "one", "first" )   
	ap_cookieWrite( "two", "second" )

	hHeaders := ap_getHeadersOut()
   
	for each hKey in hHeaders
		? hKey:__enumKey(), "=>", hKey:__enumValue()
	next    

	? ap_cookieRead( "two" )

return 
