//	-----------------------------------------------------------	//

CLASS THDO

   DATA cType    					INIT 'DBF'
   DATA cTable    					INIT ''
   DATA cAlias						INIT ''
   DATA cFocus						INIT ''
   DATA lOpen 						INIT .F.
   DATA aFields 						INIT {=>}

   METHOD  New() CONSTRUCTOR
   
   METHOD  AddField( cField ) 		INLINE ::aFields[ cField ] := {}
   METHOD  Open()					
   METHOD  OpenDbf()					
   METHOD  Focus( cFocus )
   METHOD  Seek( cKey )
   METHOD  Load()


ENDCLASS

METHOD New() CLASS THDO

RETU Self

METHOD Open() CLASS THDO

	LOCAL oError, bError, cError
	LOCAL cPath
	
	IF ::lOpen	
		RETU NIL
	ENDIF	

	DO CASE 
		CASE ::cType == 'DBF' ; ::OpenDbf()				
	ENDCASE			   

RETU NIL

METHOD OpenDbf( ) CLASS THDO

	LOCAL cPath 	:= AP_GETENV( 'DOCUMENT_ROOT' ) + AP_GETENV( 'PATH_APP' ) + '/data/'
	LOCAL cFile 	:= cPath + ::cTable
	LOCAL bError   	:= Errorblock({ |o| ErrorHandler(o) })
	LOCAL cError 	:= ''

	BEGIN SEQUENCE

	   USE ( cFile ) SHARED NEW VIA "DBFCDX"
	   
		::cAlias 	:= Alias()
		::lOpen 	:= .T.
		
		IF ( !empty( ::cFocus  ) )		
			( ::cAlias )->( OrdSetFocus( ::cFocus ) )
		ENDIF
	
	RECOVER USING oError

	  cError := 'File: ' + cFile + '<br>'
		
	  cError += 'Error Description: '
		
	  cError += if( ValType( oError:SubSystem   ) == "C", oError:SubSystem(), "???" )
	  cError += if( ValType( oError:SubCode     ) == "N", "/" + ltrim(str(( oError:SubCode ))), "/???" )
	  cError += if( ValType( oError:Description ) == "C", "  " + oError:Description, "" )
  
	  ? cError
	  
	  QUIT		//	Ya veremos como tratamos errores...

	END SEQUENCE	
	
RETU .T.


METHOD Focus( cFocus ) CLASS THDO

	::Open()

	IF ::lOpen	
		( ::cAlias )->( OrdSetFocus( cFocus ) )				
	ENDIF
	
RETU NIL 

METHOD Seek( n ) CLASS THDO

	LOCAL hReg 		:= {=>}
	LOCAL cField, nI
	LOCAl lFound 	:= .F.

	::Open()
		
	IF !::lOpen	
		RETU hReg
	ENDIF

	lFound 	:= (::cAlias)->( DbSeek( n ) )		

	hReg 	:= ::Load()

RETU hReg

METHOD Load() CLASS THDO

	LOCAL nI, cField 
	LOCAL hReg := {=>}

	FOR nI := 1 TO Len( ::aFields )
	
		cField := HB_HPairAt( ::aFields, nI )[1]				
		hReg[ cField ] :=  ValToChar((::cAlias)->( FieldGet( FieldPos( cField ) ) ))
		
	NEXT

RETU hReg

*-----------------------------------
STATIC FUNCTION ErrorHandler(oError)
*-----------------------------------

    BREAK oError

RETU NIL

