procedure main()

	local h := { 'username' => 'maria', 'passw' => 123 }
	
	ap_echo( 1 )
	ap_echo( 2 )
	ap_echo( 3 )
	ap_echo( 4 )
	ap_echo( 5 )
	ap_echo( ' ===> ' )	
	ap_echo( time(), '<hr>' )	
	ap_echo( h )
	ap_echo( 'hola friend' )
	ap_echo( 1234 )	
	ap_echo( 'Test1', 678, date(), .T., { 'aaa', 'bbb', 'ccc' }, { 'user' => 'kym', 'psw' => 123 } )
	ap_echo( '<br>', 'a', 1234 )
	ap_echo( "un objeto", '<hr>' )
	ap_echo( ErrorNew() )
	?
	?
	ap_echo( "Un nulo", '<hr>' )	
	ap_echo()

return	