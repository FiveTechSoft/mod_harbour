procedure main()

	local aH := {=>}	
	
	aH[ 'time' ] := time()
	aH[ 'date' ] := date()
	aH[ 'age' ] := 123
	aH[ 'married' ] := .T.
	
	ap_setContentType( "application/json" )
	
	?? hb_jsonEncode( aH )	

return 
