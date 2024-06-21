procedure main()

	local n := seconds()	
	
	? "Empieza en 0"
	hb_idleSleep( 5 )	// Espera 5 sec
	? seconds() - n, 'sec.'
	
return 
