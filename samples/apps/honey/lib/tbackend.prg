/*	--------------------------------------------------------------------------
	Sistema de Vistas
------------------------------------------------------------------------------ */

FUNCTION View( cPrg, ... )

	LOCAL cFile := hb_GetEnv( "HONEY_APP" ) + '/src/view/' + cPrg 
	LOCAL cCode := MemoRead( cFile )
	LOCAL o 		:= ''
	
	AP_RPuts( InlinePrg( cCode, o, nil, ... ) )	

RETU NIL

FUNCTION Url_Base() ; 		return hb_GetEnv( "HONEY_URL" )
FUNCTION Url_Controller() ; 	return "/modharbour_samples/apps/honey/src/controller/"
FUNCTION Url_Model() ; 		return hb_GetEnv( "HONEY_URL" ) + '/src/model/'
FUNCTION Url_View() ; 		return hb_GetEnv( "HONEY_URL" ) + '/src/view/'
FUNCTION Url_Images() ;         return "/modharbour_samples/apps/honey/images/"
FUNCTION Url_Photos() ;         return "/modharbour_samples/apps/honey/photos/"

FUNCTION TGet( cKey, uDefault )

	STATIC hGet 	:= NIL	
	LOCAL cArgs, cPart	
	
	IF Valtype( hGet ) <> 'H' 
	
		hGet 	:= {=>}		
		cArgs 	:= AP_Args()
		
		FOR EACH cPart IN hb_ATokens( cArgs, "&" )
		
			IF ( nI := At( "=", cPart ) ) > 0
				hGet[ lower(Left( cPart, nI - 1 )) ] := Alltrim(SubStr( cPart, nI + 1 ))
			ELSE
				hGet[ lower(cPart) ] :=  ''
		    ENDIF
		   
		NEXT							
	
	ENDIF			

	hb_default( @cKey, '' )
	hb_default( @uDefault, '' )
	
	cKey := lower( cKey )
	
	IF hb_HHasKey( hGet, cKey )
		uValue := hGet[ cKey ]
	ELSE
		uValue := uDefault
	ENDIF

RETU uValue

FUNCTION TPost( cKey, uDefault )

	STATIC hPost 	:= NIL	
	LOCAL cArgs, cPart
	
	IF Valtype( hPost ) <> 'H' 

		hPost := {=>}
		
		IF ( nForm := AP_PostPairsCount() ) > 0

			FOR nNum := 0 to nForm - 1
				hPost[ AP_PostPairsKey( nNum ) ] := AP_PostPairsVal( nNum ) 
			NEXT

		ENDIF

	ENDIF

	hb_default( @cKey, '' )
	hb_default( @uDefault, '' )
	
	cKey := lower( cKey )
	
	IF hb_HHasKey( hPost, cKey )
		uValue := hPost[ cKey ]
	ELSE
		uValue := uDefault
	ENDIF

RETU uValue
