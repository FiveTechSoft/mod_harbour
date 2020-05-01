function Main()

	local hHash := {=>}	
	
	hHash[ 'time' ] = time()
	hHash[ 'date' ] = date()
	hHash[ 'age'  ] = 123

  ? "From PRG (json) to Javascript (object)"	
    
	?? "<script>"
	?? "var object=" + hb_jsonEncode( hHash, .T. ) + ";"
	?? "alert( object.time );"
	?? "alert( object.date );"
	?? "alert( object.age );"
	?? "</script>"

return nil 
