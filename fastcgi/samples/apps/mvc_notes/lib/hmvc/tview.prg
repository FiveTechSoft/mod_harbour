//	-----------------------------------------------------------	//

CLASS TView

	DATA oRoute				INIT ''	
	
	METHOD New() CONSTRUCTOR	

	METHOD Load( cFile ) 
	METHOD Exec( cFile, ... ) 
	
ENDCLASS 

METHOD New() CLASS TView
		
RETU Self


METHOD Load( cFile ) CLASS TView

	//	Por defecto la carpeta de los views estaran en src/view

	LOCAL cPath 		:= AP_GETENV( 'DOCUMENT_ROOT' ) + AP_GETENV( 'PATH_APP' ) + '/src/view/'
	LOCAL cCode 		:= ''
	LOCAL cProg

	__defaultNIL( @cFile, '' )
	
	cProg 				:= cPath + cFile
	
	LOG 'View: ' + cProg
	LOG 'Existe fichero? : ' + ValToChar(file( cProg ))
	
	IF File ( cProg )
	
		cCode := MemoRead( cProg )	
	
	ENDIF				

RETU cCode

METHOD Exec( cFile, ... ) CLASS TView

	LOCAL o 		:= ''		
	LOCAL cCode  	:= ::Load( cFile )
	
	IF !empty( cCode )

		//ReplaceBlocks( @cCode, "{{", "}}" )
		zReplaceBlocks( @cCode, '{{', '}}', cFile, ... )
		
		LOG '<b>CODE Replaced</b><br>'		

		AP_RPuts( InlinePrg( cCode, o, nil, ... ) )				
	
	ELSE
	
		LOG 'Error: No existe Vista: ' + cFile 
		? '<h2>Error: No existe Vista: ', cFile , '</h2>'
	
	ENDIF				

RETU ''

FUNCTION zReplaceBlocks( cCode, cStartBlock, cEndBlock, cFile, ... )

	LOCAL nStart, nEnd, cBlock
	LOCAL lReplaced 		:= .F.
	LOCAL uValue, bBloc 
	LOCAL cCodeA, cCodeB
	LOCAL oInfo     		:= {=>}
    LOCAL bErrorHandler 	:= { |oError | MyErrorHandler(oError, oInfo ) }
	LOCAL bLastHandler 	:= ErrorBlock(bErrorHandler)
	LOCAL hPP
   
	hb_default( @cStartBlock, "{{" )
	hb_default( @cEndBlock, "}}" )

	oInfo[ 'file' ] := cFile
	oInfo[ 'block' ] := 0    
   
	//Posar hPP com a data
	
    hPP := __pp_init()
	__pp_addRule( hPP, "#xcommand PARAM <nParam> => _get( pvalue(<nParam>) )" )
	__pp_addRule( hPP, "#xcommand PARAM <nParam>,<uIndex> => _get( hb_pvalue(<nParam>),<uIndex> )" )

	while ( nStart := At( cStartBlock, cCode ) ) != 0 .and. ;
         ( nEnd := At( cEndBlock, cCode ) ) != 0		 
		 
		 oInfo[ 'block' ]++		 
		 
		cCodeA := SubStr( cCode, 1, nStart - 1 ) 
		cCodeB := SubStr( cCode, nEnd + Len( cEndBlock ) )

		cBlock := SubStr( cCode, nStart + Len( cStartBlock ), nEnd - nStart - Len( cEndBlock ) )
		cBlock := alltrim(cBlock)
		uValue := ''
		
		oInfo[ 'code' ] := '{{ ' + cBlock + ' }}'
		
	    IF !empty( cBlock )
		  
			cBlock := __pp_process( hPP, cBlock )

			bBloc  := &( '{|...| '  + cBlock + ' }' )
			uValue := Eval( bBloc, ... )

			IF Valtype( uValue ) <> 	'C'

				uValue := ValToChar( uValue )

			ENDIF	 

	    ENDIF
	  
		cCode  := cCodeA + uValue + cCodeB
	  
		lReplaced := .T.
    end
   
    ErrorBlock(bLastHandler) // Restore handler    
   
RETU lReplaced

FUNCTION _get( uValue, uInd )

	LOCAL cTypeValue	:= Valtype( uValue )
	LOCAL cType 		:= ValType( uInd )

	DO CASE
	
		CASE cTypeValue == 'C'
			
		CASE cTypeValue == 'A'
		
			IF cType == 'N'
				uValue := uValue[ uInd ]
			ELSE
				uValue := ValToChar( uValue )
			ENDIF
		
		CASE cTypeValue == 'H'
	
			IF cType == 'C' .AND. hb_HHasKey( uValue, uInd )
				uValue := uValue[ uInd ]	
			ELSE
				uValue := VTC( uValue )
			ENDIF
			
		OTHERWISE

			uValue := ValToChar( uValue )
		
	ENDCASE		

RETU uValue

FUNCTION VTC( u )
	IF Valtype( u ) == 'H'
		RETU 'HASSSSH' 
	ELSE
		RETU ValToChar( u )
	ENDIF
	
RETU NIL

FUNCTION ExecInline2( cCode, cParams, ... )		

    IF cParams == nil
       cParams = ""
    ENDIF 

RETU Execute2( "FUNCTION __Inline( " + cParams + " )" + HB_OsNewLine() + "RETU " + cCode, ... )

FUNCTION Execute2( cCode, ... )

   LOCAL oHrb, uRet
   LOCAL cHBheaders := "~/harbour/include"
   
	        hPP = __pp_init()
			__pp_addRule( hPP, "#xcommand PVALUE <cKey> => HB_PValue(1)\[ <cKey> \]" )
			__pp_addRule( hPP, "#xcommand PVALUE <cKey>,<cInd> => HB_PValue(1)\[ <cKey> \]\[<cInd>\]" )
			   

   cCode = __pp_process( hPP, cCode )

   oHrb = HB_CompileFromBuf( cCode, .T., "-n", "-I" + cHBheaders )

   IF ! Empty( oHrb )
      uRet = hb_HrbDo( hb_HrbLoad( oHrb ), ... )
   ENDIF
   
RETU uRet


FUNCTION MyErrorHandler( oError, oInfo )	

	LOCAL cInfo 		:= ''
	LOCAL cCallStack 	:= ''
	LOCAL cHtml 		:= ''
	LOCAL cContent 	:= ''
	LOCAL cArgs 		:= ''
	LOCAL n

	 cContent +=  'File: ' + oInfo[ 'file' ] + '<br>'
	 cContent +=  'Error: ' + oError:description + '<br>'
	 cContent +=  'Block: ' + ltrim(str(oInfo[ 'block' ])) + '<br>'
	 cContent +=  'Code: ' + oInfo[ 'code' ] + '<br>'
	  
   
    IF ValType( oError:Args ) == "A"
      cArgs += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cArgs += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + ValToChar( oError:Args[ n ] ) + hb_OsNewLine()
      next
    ENDIF
	
    IF !empty( cArgs )
		cContent +=  'Args: ' + cArgs + '<br>'
	ENDIF

	? cContent

    BREAK oError      // RETU error object to RECOVER	  

RETU NIL



//	-----------------------------------------------------------	//

FUNCTION View( cFile, ... )

	LOCAL cCode := ''
	LOCAL oView := TView():New()
	
	cCode := oView:Load( cFile )
	
	zReplaceBlocks( @cCode, '{{', '}}', cFile, ... )	

retu cCode