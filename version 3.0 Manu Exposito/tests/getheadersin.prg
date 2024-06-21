procedure main()
	
	local hHeader := ap_getHeadersIn()
	local hKey := nil 
	
	for each hKey in hHeader	
		? hKey:__enumKey(), "=>", hKey:__enumValue()
	next 
   
return
