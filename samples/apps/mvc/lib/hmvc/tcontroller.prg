
//	-----------------------------------------------------------	//

CLASS TController

	DATA oView
	DATA cAction 				INIT ''
	DATA hParam					INIT {=>}
	DATA cargo					
	
	METHOD New( cAction, hPar ) CONSTRUCTOR
	METHOD View( cFile, ... ) 					INLINE ::oView:Exec( cFile, ... )
	METHOD List()
	
ENDCLASS 

METHOD New( cAction, hPar  ) CLASS TController
		
	::cAction 	:= cAction
	::hParam 	:= hPar	
	
	::oView 	:= TView():New()

RETU Self

METHOD List() CLASS TController



RETU 



//	-----------------------------------------------------------	//