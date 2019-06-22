function main()

	?? '<h2>Config MVC</h2><pre>' 
	
	?  'Aplication Name', ap_getenv( 'APP_TITLE' )
	?  'Aplication Path', ap_getenv( 'PATH_APP' )
	?  'Aplication URL' , ap_getenv( 'PATH_URL' )
	?  'Aplication Data', ap_getenv( 'PATH_DATA' )

	?  'PRGPATH', hb_GetEnv( "PRGPATH" )
	
retu nil