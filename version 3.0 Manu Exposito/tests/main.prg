/*
 The first function we declare will always be executed.
 If we have defined INIT PROC <cName>, it will always be
 executed before the first function declared. We can have
 several INIT PROC, which will be executed sequentially
 LIFO style 
*/

procedure Mary()

	? "I'm Mary() the first funcion ->", time() + ' ' + dtoc( date() )

return

procedure OtherFunc()
	
	? "I'm otherfunc()"
	
return

init procedure main

	? "I'm main "
	
return 

init procedure main2
	
	? "I'm main2 "
	
return 