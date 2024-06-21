procedure main()

	local h := { 'username' => 'maria', 'passw' => 123 }
	
	ap_rputs( 1 )
	ap_rputs( 2 )
	ap_rputs( 3 )
	ap_rputs( 4 )
	ap_rputs( 5 )
	ap_rputs( ' ===> ' )	
	ap_rputs( time(), '<hr>' )	
	ap_rputs( h )
	ap_rputs( 'hola friend' )
	ap_rputs( 1234 )	
	ap_rputs( 'Test1', 678, date(), .T., { 'aaa', 'bbb', 'ccc' }, { 'user' => 'kym', 'psw' => 123 } )
	ap_rputs( '<br>', 'a', 1234 )
	ap_rputs( "un objeto", '<hr>' )
	ap_rputs( ErrorNew() )
	?
	?
	ap_rputs( "Un nulo", '<hr>' )	
	ap_rputs()

return	