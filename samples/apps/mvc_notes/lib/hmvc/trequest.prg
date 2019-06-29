//	-----------------------------------------------------------	//


CLASS TRequest

   DATA hGet					INIT {=>}
   DATA hPost					INIT {=>}
   DATA hCgi					INIT {=>}

   METHOD New() CONSTRUCTOR
   METHOD Method()						INLINE AP_GetEnv( 'REQUEST_METHOD' )
   METHOD Get( cKey, uDefault, cType )
   METHOD GetAll()						INLINE ::hGet
   METHOD Post( cKey, uDefault, cType )
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

METHOD Get( cKey, uDefault, cType ) CLASS TRequest

	LOCAL nType 
	LOCAL uValue	:= ''

	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )
	__defaultNIL( @cType, '' )		
	
	IF !empty(cKey) .AND. hb_HHasKey( ::hGet, cKey )
		uValue := hb_UrlDecode(::hGet[ cKey ])
	ELSE
		uValue := uDefault
	ENDIF

	DO CASE
		CASE cType == 'C'
		CASE cType == 'N'		
			uValue := Val( uValue )
	ENDCASE		

RETU uValue

METHOD Post( cKey, uDefault, cType ) CLASS TRequest

	LOCAL nType 
	LOCAL uValue 	:= ''
	
	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )	
	__defaultNIL( @cType, '' )			

	IF hb_HHasKey( ::hPost, cKey )
		uValue := hb_UrlDecode(::hPost[ cKey ])
	ELSE
		uValue := uDefault
	ENDIF
	
	DO CASE
		CASE cType == 'C'
		CASE cType == 'N'		
			uValue := Val( uValue )
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
	
	//	Bug AP_PostPairs, si esta vacio devuelve un hash de 1 posicion sin key ni value
	
	IF Len( ::hPost ) == 1 .AND. empty( HB_HKeyAt( ::hPost, 1 ) )
		::hPost := {=>}
	ENDIF 

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

