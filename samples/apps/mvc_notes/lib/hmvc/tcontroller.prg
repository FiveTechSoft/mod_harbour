
//	-----------------------------------------------------------	//

CLASS TController

	DATA oRequest	
	DATA oView
	DATA cAction 				INIT ''
	DATA hParam					INIT {=>}
	DATA aRouteSelect			INIT {=>}
	DATA hValidate				INIT {=>}
	DATA aErrorMessages			INIT {}
	
	CLASSDATA cargo					
	
	METHOD New( cAction, hPar ) CONSTRUCTOR
	METHOD View( cFile, ... ) 					
	METHOD ListController()
	METHOD ListRoute()								INLINE ::cargo:ListRoute()
	
	METHOD GetValue( cKey, cDefault, cType )		INLINE ::oRequest:Get( cKey, cDefault, cType )
	METHOD PostValue( cKey, cDefault, cType )		INLINE ::oRequest:Post( cKey, cDefault, cType )
	
	METHOD Validate( hValidate )				
	METHOD EvalValue( cKey, cValue )				
	METHOD ErrorMessages()							INLINE ::aErrorMessages
	METHOD Response( uData )		
	
ENDCLASS 

METHOD New( cAction, hPar  ) CLASS TController
		
	::cAction 	:= cAction
	::hParam 	:= hPar	
	
	::oView 		:= TView():New()
	::oView:oRoute 	:= ::cargo

RETU Self

METHOD View( cFile, ... ) CLASS TController

	::oView:Exec( cFile, ... )

RETU ''

METHOD Validate( hValidate ) CLASS TController

	LOCAL a, n, aH, cKey, cValue
	LOCAL lValidate := .T.	

	::hValidate := hValidate		
	
	FOR n := 1 to len( ::hValidate )
	
		aH := hb_HPairAt( ::hValidate, n )
		
		cKey 	:= aH[1]
		cValue 	:= aH[2]
		
		hMsg := ::EvalValue( cKey, cValue )
		
		IF hMsg[ 'success' ] == .F.
			
			Aadd( ::aErrorMessages, hMsg )
			
		ENDIF
	
	NEXT

	lValidate := len( ::aErrorMessages ) == 0

	//	xec ->getmessages()
	//	xec ->fails()	

RETU lValidate


METHOD EvalValue( cKey, cValue ) CLASS TController

	LOCAL oReq 		:= ::cargo:oTRequest
	LOCAL aRoles, n, nRoles, cRole
	LOCAL uValue :=  oReq:Get( cKey )
	LOCAL cargo
	LOCAL cMethod 	:= oReq:Method()
	
	__defaultNIL( @cValue, '' )

	
	DO CASE
		CASE cMethod == 'GET'	;	uValue := oReq:Get( cKey )
		CASE cMethod == 'POST'	;	uValue := oReq:Post( cKey )
	ENDCASE
	
	
	aRoles := HB_ATokens( cValue, '|' )
	nRoles := len( aRoles )	

	//? '<hr>Chequear: ' , cKey, 'Value: ', uValue, 'con ==> ', cValue
	
	//	Se han de chequear todos los roles...
	
	FOR n = 1 to nRoles
	
		cRole := alltrim(lower(aRoles[n]))
		
		DO CASE
			CASE cRole == 'required'
			
				IF empty( uValue )
					RETU { 'success' => .F., 'field' => cKey,  'msg' => 'Paràmetro requerido: ' + cKey, 'value' => uValue }
					EXIT
				ENDIF
				
			CASE cRole == 'numeric'
	
				IF ! ISDIGIT( uValue )
					RETU { 'success' => .F., 'field' => cKey,   'msg' => 'Valor no nomérico: ' + cKey , 'value' => uValue }
					EXIT
				ENDIF

			CASE cRole == 'string'
	
				IF ! ISALPHA( uValue )
					RETU { 'success' => .F., 'field' => cKey,   'msg' => 'Valor no string: ' + cKey, 'value' => uValue  }
					EXIT
				ENDIF

			CASE substr(cRole,1,4) == 'len:'

				cargo := Val(substr(cRole, 5 ))

				IF len( uValue ) > cargo	
					RETU { 'success' => .F., 'field' => cKey,   'msg' => 'Maxima logintud de ' + ltrim(str(cargo)), 'value' => uValue  }
					EXIT
				ENDIF
				
		ENDCASE		
		
	NEXT								

RETU { 'success' => .T. }
 
METHOD Response( uData ) CLASS TController

	LOCAL n 
	
	//	Pendiente de diseñar...
	
RETU NIL

METHOD ListController() CLASS TController

	LOCAL oThis := SELF		
	
	TEMPLATE PARAMS oThis
	
		<b>ListController</b><hr><pre>
		
		<table border="1" style="font-weight:bold;">
		
			<thead>
				<tr>
					<th>Description</th>
					<th>Parameter</th>
					<th>Value</th>							
				</tr>									
			</thead>
			
			<tbody>
			
				<tr>
					<td>ClassName Name</td>
					<td>ClassName()</td>
					<td><?prg retu oThis:ClassName() ?></td>
				</tr>
				
				<tr>
					<td>Action</td>
					<td>cAction</td>
					<td><?prg retu oThis:cAction ?></td>
				</tr>				
			
				<tr>
					<td>Parameters</td>
					<td>hParam</td>
					<td><?prg retu ValToChar( oThis:hParam ) ?></td>
				</tr>				
				
				<tr>
					<td>Method</td>
					<td>oRequest:method()</td>
					<td><?prg retu oThis:oRequest:method() ?></td>
				</tr>
				
				<tr>
					<td>Query</td>
					<td>oRequest:GetQuery()</td>
					<td><?prg retu oThis:oRequest:getquery() ?></td>
				</tr>				

				<tr>
					<td>Parameters GET</td>
					<td>oRequest:CountGet()</td>
					<td><?prg retu ValToChar(oThis:oRequest:countget()) ?></td>
				</tr>	

				<tr>
					<td>Value GET</td>
					<td>oRequest:Get( cKey )</td>
					<td><?prg retu ValToChar(oThis:oRequest:getall()) ?></td>
				</tr>

				<tr>
					<td>Parameters POST</td>
					<td>oRequest:CountPost()</td>
					<td><?prg retu ValToChar(oThis:oRequest:countpost()) ?></td>
				</tr>	

				<tr>
					<td>Value POST</td>
					<td>oRequest:Post( cKey )</td>
					<td><?prg retu ValToChar(oThis:oRequest:postall()) ?></td>
				</tr>	

				<tr>
					<td>Route Select</td>
					<td>aRouteSelect</td>
					<td><?prg retu ValToChar(oThis:aRouteSelect) ?></td>
				</tr>				
				
			
			</tbody>		
			
		</table>

		</pre>
		
   
   ENDTEXT

RETU 




//	-----------------------------------------------------------	//