//	-----------------------------------------------------------	//


CLASS TRequest

   DATA hGet					INIT {=>}
   DATA hPost					INIT {=>}
   DATA hCgi					INIT {=>}

   METHOD New() CONSTRUCTOR
   METHOD Method()						INLINE AP_GetEnv( 'REQUEST_METHOD' )
   METHOD Get( cKey, uDefault )
   METHOD GetAll()						INLINE ::hGet
   METHOD Post( cKey, uDefault )
   METHOD PostAll()						INLINE ::hPost
   METHOD Cgi ( cKey )
   METHOD CountGet()						INLINE len( ::hGet )
   METHOD CountPost()						INLINE len( ::hPost )
   METHOD LoadGet()
   METHOD LoadPost()
   METHOD GetQuery()

ENDCLASS

METHOD New() CLASS TRequest

	LOG 'QUERY: ' + ::GetQuery()
	LOG 'METHOD: ' + ::Method()
		
	::LoadGet()	
	::LoadPost()	

return Self

METHOD Get( cKey, uDefault ) CLASS TRequest

	LOCAL nType 
	LOCAL uValue	:= ''

	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )	
	
	nType := ValType( cKey )

	DO CASE
		CASE nType == 'C'	
	
			cKey := lower( cKey )		
			
			IF !empty(cKey) .AND. hb_HHasKey( ::hGet, cKey )
				uValue := ::hGet[ cKey ]
			ELSE
				uValue := uDefault
			ENDIF
			
			
		CASE nType == 'N'	//	Position
		
			IF cKey > 0 .AND. cKey <= ::CountGet()		
				uValue := hb_HValueAt( ::hGet, cKey )
			ENDIF
			
	ENDCASE			

RETU uValue

METHOD Post( cKey, uDefault ) CLASS TRequest

	LOCAL nType 
	LOCAL uValue 	:= ''
	
	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )	
	
	nType := ValType( cKey )

	DO CASE
		CASE nType == 'C'
		
			cKey := lower( cKey )
			
			IF hb_HHasKey( ::hPost, cKey )
				uValue := ::hPost[ cKey ]
			ELSE
				uValue := uDefault
			ENDIF
			
		CASE nType == 'N'	//	Position
		
			IF cKey > 0 .AND. cKey <= ::CountPost()		
				uValue := hb_HValueAt( ::hPost, cKey )
			ENDIF
			
	ENDCASE

RETU uValue


METHOD LoadGet() CLASS TRequest

	LOCAL cArgs := AP_Args()
	LOCAL cPart	
	
	FOR EACH cPart IN hb_ATokens( cArgs, "&" )
	
		IF ( nI := At( "=", cPart ) ) > 0
			::hGet[ lower(Left( cPart, nI - 1 )) ] := Alltrim(SubStr( cPart, nI + 1 ))
		ELSE
			::hGet[ lower(cPart) ] :=  ''
		ENDIF
	   
	NEXT							


RETU NIL

METHOD LoadPost() CLASS TRequest

	::hPost := AP_PostPairs()

RETU NIL

METHOD Cgi( cKey ) CLASS TRequest

	LOCAL uValue := ''
	
	__defaultNIL( @cKey, '' )		
	
	uValue := AP_GetEnv( cKey )

RETU uValue

METHOD GetQuery() CLASS TRequest

	LOCAL cPath, n, cQuery

	cPath := _cFilePath( ::Cgi( 'SCRIPT_NAME' ) )
	
	LOG 'GetQuery() Path: ' + cPath
	
	n := At( cPath, ::Cgi( 'REQUEST_URI' ) )
	
	cQuery := Substr( ::Cgi( 'REQUEST_URI' ), n + len( cPath ) ) 
	
	IF ( len(cQuery ) == 0 )
		cQuery := '/'
	ENDIF

RETU cQuery

static function _cFilePath( cFile )   // returns path of a filename

   //local lLinux := If( "Linux" $ OS(), .T., .F. )
   //local cSep := If( lLinux, "\", "/" )
   LOCAL cSep := '/'
   local n := RAt( cSep, cFile )

RETU Substr( cFile, 1, n )

