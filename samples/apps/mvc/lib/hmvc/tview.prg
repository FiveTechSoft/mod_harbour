//	-----------------------------------------------------------	//

CLASS TView

	DATA cDummy				INIT ''	
	
	METHOD New() CONSTRUCTOR
	
	METHOD Exec( cFile, ... ) 
	
ENDCLASS 

METHOD New() CLASS TView
		
RETU Self

METHOD Exec( cFile, ... ) CLASS TView

	//	Por defecto la carpeta de los views estaran en src/view

	LOCAL cPath 		:= '{% PathBase( '/src/view/' ) %}'
	LOCAL cCode, cProg
	LOCAL o 			:= ''	

	__defaultNIL( @cFile, '' )
	
	cProg 				:= cPath + cFile
	
	LOG 'View: ' + cProg
	LOG 'Existe fichero? : ' + ValToChar(file( cProg ))
	
	IF File ( cProg )
	
		cCode := MemoRead( cProg )
		
		LOG '<b>Code</b>' + cCode		

		ReplaceBlocks( @cCode, "{{", "}}" )
		
		LOG '<b>CODE Replaced</b><br>'

		AP_RPuts( InlinePrg( cCode, o, nil, ... ) )		
		
	
	ELSE
	
		LOG 'Error: No existe Vista: ' + cFile 
		? '<h2>Error: No existe Vista: ', cFile , '</h2>'
	
	ENDIF				

RETU ''