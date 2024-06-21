procedure main()

	local h := { 'username' => 'maria', 'passw' => 123 }
	
	ap_rwrite( 1 )
	ap_rwrite( 2 )
	ap_rwrite( 3 )
	ap_rwrite( 4 )
	ap_rwrite( 5 )
	ap_rwrite( ' ===> ' )	
	ap_rwrite( time(), '<hr>' )	
	ap_rwrite( h )
	ap_rwrite( 'hola friend' )
	ap_rwrite( 1234 )	
	ap_rwrite( 'Test1', 678, date(), .T., { 'aaa', 'bbb', 'ccc' }, { 'user' => 'kym', 'psw' => 123 } )
	ap_rwrite( '<br>', 'a', 1234 )
	ap_rwrite( "un objeto", '<hr>' )
	ap_rwrite( ErrorNew() )
	?
	?
	ap_rwrite( "Un nulo", '<hr>' )	
	ap_rwrite()

return	