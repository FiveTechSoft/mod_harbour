
function error4()

	local a 	:= version()
	local cHtml := ''
	local u
	
	BLOCKS TO cHtml PARAMS a
		La Maria 
		se marcho de viaje
		a ->  {{ a 	}} 			
		Ultima Linea
	ENDTEXT 

    BLOCKS TO cHtml PARAMS a
        Una linea
		Dos linees
		Tres linees
			
		Test a->  {{ a }} 	
		Test abc->  {{ a }} 	//	change a for abc 
			
		Antepenultima Linea
		Penultima Linea
		Ultima Linea

	ENDTEXT 		
		
	? cHtml
	? 'Fin a las ' , time()
	a()	
return
	
function a()
return b()

function b()
retu c()

function c()

	local a := 5
	local b := .t.
	local c := a + b
	
	//a+5
	
return .t.