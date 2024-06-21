procedure main()

	mh_setErrorBlock( { | hError | MyError( hError ) } )
	
	? a + 5
	
return 

procedure MyError( hError )

	? hError
	
return
