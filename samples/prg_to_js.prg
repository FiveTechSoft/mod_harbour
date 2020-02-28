function Main()

	local aH := {=>}	
	
	aH[ 'time' ] = time()
	aH[ 'date' ] = date()
	aH[ 'age'  ] = 123

  ? "From PRG (json) to Javascript (object)"	
    
	?? "<script>"
	?? "var object=" + hb_jsonEncode( aH, .T. ) + ";"
	?? "alert( object.time );"
	?? "alert( object.date );"
	?? "alert( object.age );"
	?? "</script>"

return nil 
