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
	
	LOCAL cPath := '{% PathBase( '/src/controller/' ) %}'

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


