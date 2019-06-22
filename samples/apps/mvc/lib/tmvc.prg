{% MemoRead( hb_GetEnv( "PRGPATH" ) + "\include\hbclass.ch") %}
{% MemoRead( hb_GetEnv( "PRGPATH" ) + "\include\hboo.ch") %}

//#define __LOG__

#ifdef __LOG__
	#xcommand log <cText> => TLog( <cText> )	//	Tracear el sistema
 #else
	#xcommand log <cText> =>
#endif

//	-----------------------------------------------------------	//

CLASS TRoute

	DATA oTRequest
	DATA aMap						INIT {}	

	METHOD New() CONSTRUCTOR
	
	METHOD Map( cMethod, cRoute, pController ) 
	METHOD List()
	METHOD Listen()
	METHOD Execute()

ENDCLASS

METHOD New( oApp ) CLASS TRoute

	::oTRequest := TRequest():New()	

RETU Self


METHOD Map( cMethod, cRoute, pController ) CLASS TRoute

	Aadd( ::aMap, { cMethod, cRoute, pController, '', '' } )

RETU NIL

METHOD List() CLASS TRoute

	LOCAL n, nLen := len( ::aMap )
	LOCAl cHtml
	
	? '<hr><b>Mapping List</b><pre>'
	
	cHtml := '<table>'
	cHtml += '<thead style="font-weight:bold;"><tr ><td>Metodo</td><td>Map</td><td>Route</td></tr></thead><tbody>'
	
	FOR n := 1 TO nLen 
		cHtml += '<tr><td>' + ::aMap[n][1] + '</td><td>' + ::aMap[n][2] + '</td><td>'+ ::aMap[n][3] + '</td></tr>'
	NEXT		
	
	cHtml += '</tbody></table>'
	
	?? cHtml
	
	?? '</pre><hr>'

RETU ''

METHOD Listen() CLASS TRoute

	LOCAL n, nLen 	:= len( ::aMap )
	LOCAL cMethod 	:= ::oTRequest:Method()
	LOCAL cRoute, aRoute
	LOCAL cURLQuery := ::oTRequest:GetQuery()
	LOCAL nMask, nOptional, nPosParam, nPosMapingQuery
	LOCAL cParamsMap, aParamsMap, aParamsQuery, cParamURL, aParamsURL
	LOCAL uController := ''
	LOCAL nJ, nPar
	LOCAL hParameters := {=>}
	LOCAL cParamName
	LOCAL aMapSelect := {}

	//	Buscamos en la lista de Maps, cualquier RUTA que coincida
	//	con la Query que nos han pasado. Tambien ha de coincidir
	//	con el method llamado, que en principio sera GET/POST 
	
	LOG 'Query URL: ' + cUrlQuery		
	
	//	Recolectamos todos los maps en un array de los que tengan el metodo igual. Los 
	//	otros no hace falta procesarlos: Si tenemos un map DELETE o POST y nos llega un 
	//	de tipo GET, solo procesamos los de tipos GET
	
	LOG '<hr>Recolectamos mapping...'
	
	FOR n := 1 TO nLen 
	
		aRoute := ::aMap[n]
		
		IF aRoute[1] == cMethod		
	
			cRoute := aRoute[2]
			
			LOG 'Check: ' + Valtochar(aRoute) +  '==>' + cRoute									
			
			nMask 		:= At( '(', cRoute )
			nOptional 	:= At( '[', cRoute )
			nPosParam	:= Min( nMask, nOptional )
			
			IF ( nMask > 0 .AND. nOptional > 0 )
				nPosParam := Min( nMask, nOptional )
			ELSE
				nPosParam := Max( nMask, nOptional )			
			ENDIF
			
			IF nPosParam > 0 		
				cMap 		:= Substr( cRoute, 1, nPosParam-2 )
				cParamsMap 	:= Substr( cRoute, nPosParam )
			ELSE				
				cMap 		:= cRoute
				cParamsMap 	:= ''					
			ENDIF								
				
			Aadd( aMapSelect , { aRoute[1], alltrim(cMap), cParamsMap, aRoute[3] } )		
		
		ENDIF
		
	NEXT
	
	//	Ordenamos primero las URLS largas por si coinciden parte de ellas
	//	con cortas..
	//	Si tenemos estos 2 maps:
	//	compras/customer/
	//	compras/customer/view/(id?)
	//
	//	y en la url ponemos -> http://localhost/hweb/apps/shop/compras/customer/view 
	//	coincidiria el primer map, por esos chequearemos primero las mas largas

	bSort := {| x, y | lower(x[2]) >= lower(y[2]) }
	
	ASort( aMapSelect,nil,nil, bSort )
	
	LOG '<hr>Mapping reordenado...'
	
	FOR n := 1 TO len( aMapSelect )

		LOG ValToChar( aMapSelect[n][2] )
		
	NEXT
	
	LOG '<hr>'
	
	nLen := len( aMapSelect )
	
	FOR n := 1 TO nLen 
	
		
		//	Tratamos elemento Map
		
			aRoute 		:= aMapSelect[n]

			cMap 		:= aRoute[2]	
			
			LOG 'Map Route: ' + cMap
		
		//	Buscaremos que el map exista en la query, p.e.
		//	Si tenemos oRoute:Map( 'GET', 'compras/customer/(999)', 'edit@compras.prg' )	
		//	buscaremos 'compras/customer' si se encuentra en la URL .
		//	Si se encuentra será a partir de la posicion 1
		
			nPosMapingQuery := At( cMap, cUrlQuery )
			
			IF nPosMapingQuery == 1 	//	Existe
			
				LOG '<b>MAPPING MATCHING ==> ' + cMap + '</b>' 
			
				DO CASE
				
					CASE cMethod == 'GET'
			
						cParamsMap 	:= aRoute[3]				

						LOG 'Map Params: ' + cParamsMap						
						
						//	Trataremos los parámetros a ver si cumplen el formato...
						
							IF !empty( cParamsMap )
								aParamsMap  := HB_ATokens( cParamsMap, '/' )	
								nParamsMap	:= len( aParamsMap )
							ELSE
								aParamsMap  := {}
								nParamsMap	:= 0								
							ENDIF
						
							LOG 'Total Param Maps: ' + str(nParamsMap)
							LOG 'Param Map: ' + ValtoChar( aParamsMap )
							
							//	Se habria de validar estos parámetros que si hay algun opcional, 
							//	despues no puede haber uno obligatorio
							//	(999)/[(a-z)]/(aa)   -> NO (El 2 es opcional y hay un 3 param
							
							
							//	---------------------------
							
						//	Parámetros de la URL
						
							cParamsInQuery 	:= Substr( cUrlQuery, len(cMap)+2 )
							
							if !empty( cParamsInQuery )							
								aParamsQuery	:= HB_ATokens( cParamsInQuery, '/' )
								nParamsQuery	:= len( aParamsQuery )
							else
								aParamsQuery	:= {}
								nParamsQuery	:= 0					
							endif
							
							LOG 'Param URL: ' + cParamsInQuery
							LOG 'aParam URL: ' + ValToChar( aParamsQuery )											
						
						
						
						//	Se habra de mirar si matching parmaetros URL con parametros Mapping
						//	Condiciones
						//	Si hay definidos en el Mapping 3 parámetros, se habran de cumplir los 3.
						//	Si uno de ellos es opcional, los que le preceden han de ser opcionales...
						//	p.e.:
						//	(999)/(a-z)/[(u)]
						//	Como minimo ha de haber los mismos parametros en la url que el map. (puede
						//	haber algun param del map que sea opcional
						//	---------------------------------------------------------------------------
						
							IF nParamsQuery == nParamsMap
							
								//	
									hParameters := {=>}
								
									FOR nJ := 1 TO nParamsMap
									
										//	Extraer valor de los ( ...) o [(...)]
										
										nIni := At( '(', aParamsMap[nJ] )
										nFin := At( ')', aParamsMap[nJ] )
										
										IF ( nIni > 0 .and. ( nFin > nIni ) )
										
											cParamName := Alltrim(Substr( aParamsMap[nJ] , nIni + 1, nFin - nIni - 1 ))
									
											hParameters[ cParamName ] := aParamsQuery[ nJ ]
										
										ENDIF
										
										//	Al final del proceso de recogida de parámeros, los pondremos dentro
										//	del objeto oTRequest:hGet. Asi si se desea se podran recuperar desde
										//	otro punto del programa
										
											::oTRequest:hGet := hParameters
										
									NEXT

									
							
								//	Si tenemos formateos se habrian de validar
								//	Si el parámetro cumple la condicion de formateo..., p.e.
								//	Si (999) el parametro solo ha de tener numeros y no mas 3
								
								//	...
							
								//	Si tenemos todos los parametros correctos y cumplen el mapeo, 
								//	gestionamos el controlador a ejecutar...
								
								//	Cojeremos el 3 parámetro del mapeo. Podrá ser un puntero a 
								//	función o un controlador. El formato del controlador será
								// at the moment "metodo@fichero" p.e. -> edit@compras_controller.prg
								
								uController := aRoute[4]
								
								//	En este punto ya no habria de mirar ningun posible Map mas...
								
								EXIT
								
							ELSE 
							
								LOG 'Parámetros URL <> Mapp'
							
							ENDIF
							
					CASE cMethod == 'POST'

						hParameters := ::oTRequest:PostAll()

						uController := aRoute[4]		
						
						//	En este punto ya no habria de mirar ningun posible Map mas...
						
						EXIT
					
					ENDCASE
				
			ELSE
			
			
			ENDIF									
		
	NEXT
	
	//	Si existe un controlador lo ejecutaremos
	
	IF !empty( uController )
	
		LOG 'Se habrá de cargar el controlador y ejecutarlo pasandole lso parámetros...'
		LOG '<b>Controlador</b>: '	+ valtochar( uController )	
		LOG '<b>Parameters</b>: ' 	+ valtochar( hParameters )		
	
		::Execute( uController, hParameters )
	
	ENDIF
	
	

RETU NIL

//	En principio TRouter se ejecuta desde la raiz del programa...
//	En lugar de cojer ap_getenv( path prog), podemos cojer el path del cgi script_filename

METHOD Execute( cController, hParam ) CLASS TRoute

	//	Por defecto la carpeta de los controladores estara en srv/controller
	
	LOCAL cPath := '{% hb_GetEnv( "PRGPATH" ) %}' + '\src\controller\' 

	local cProg, cCode, cFile
	local cAction := ''
	LOCAL nPos
	
	LOG '<hr><b>Execute()</b>'
	LOG 'Exec: ' + cController
	
	nPos := At( '@', cController )
	
	if ( nPos >  0 )
		
		cAction := alltrim( Substr( cController, 1, nPos-1) )
		cFile 	:= alltrim( Substr( cController, nPos+1 ) )
	
	else
	
		cFile 	:= cController
	
	ENDIF

	cProg := cPath + cFile
	
	LOG 'Programa: ' + cProg
	
	LOG 'Action: ' + cAction
	
	LOG 'Existe fichero? : ' + ValToChar(file( cProg ))
	
	IF File ( cProg )
	
		cCode := MemoRead( cProg )
		
		LOG '<b>Code</b>' + cCode
		
		oTController 		:= TController():New( cAction, hParam )
		oTController:cargo  := SELF
		
		
		LOG '<h3>Ejecutamos Controller() ==> ' + cController + '</h3>'
		
		Execute( cCode, oTController )
	
	ELSE
	
		LOG 'Error: No existe Controller: ' + cFile 
	
	ENDIF

RETU 

//	-----------------------------------------------------------	//

CLASS TController

	DATA oView
	DATA cAction 				INIT ''
	DATA hParam					INIT {=>}
	DATA cargo					
	
	METHOD New( cAction, hPar ) CONSTRUCTOR
	METHOD View( cFile, ... ) 					INLINE ::oView:Exec( cFile, ... )
	
ENDCLASS 

METHOD New( cAction, hPar  ) CLASS TController
		
	::cAction 	:= cAction
	::hParam 	:= hPar	
	
	::oView 	:= TView():New()

RETU Self

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

	LOCAL cPath 		:= '{% hb_GetEnv( "PRGPATH" )%}' + '\src\view\' 	
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

FUNCTION TLog( uValue, cTab ) 

	LOCAL cType 	:= ValType( uValue )
	LOCAL cLine 	:= ltrim(str(procline( 1 )))
	LOCAL cPart, aKeys, cKey
	
	__defaultNIL( @cTab , '' )

	? cTab, 'Line: ' + cLine, cType	
	
	DO CASE
		CASE cType == 'C'			
			?? uValue
		CASE cType == 'H'
		
			?? 'Hash'
			
			aKeys := hb_HKeys( uValue )
			
			FOR EACH cKey IN aKeys
			
				cType := Valtype( uValue[ cKey ] )
				
				DO CASE
					CASE cType == 'H'
						? cTab, cKey, '=>', 'Hash'
						cTab := '--->'
						TLog( uValue[ cKey ], cTab )
					OTHERWISE
						? cTab, cKey, '=>', ValToChar(uValue[ cKey ])
				ENDCASE
			
			NEXT
										
		OTHERWISE
			?? ValToChar( uValue )
	ENDCASE	
	
	

RETU

//	-----------------------------------------------------------	//


CLASS THDO

   DATA cType    					INIT 'DBF'
   DATA cTable    					INIT ''
   DATA cAlias						INIT ''
   DATA cFocus						INIT ''
   DATA lOpen 						INIT .F.
   DATA aFields 					INIT {=>}

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

	LOCAL cPath 	:= '{%hb_GetEnv( "PRGPATH" )%}' + '\data\' 	
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
