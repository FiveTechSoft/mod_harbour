#include '/var/www/html/include/fileio.ch'
#include '{{ap_GetEnv("HONEY_APP")}}\include\fileio.ch'
/*
FUNCTION zTemplate( cText, ... )

   LOCAL nStart, nEnd, cCode

   WHILE ( nStart := At( "<?prg", cText ) ) != 0
      nEnd = At( "?>", SubStr( cText, nStart + 5 ) )
      cCode = SubStr( cText, nStart + 5, nEnd - 1 )
      cText = SubStr( cText, 1, nStart - 1 ) + zReplace( cCode, ... ) + SubStr( cText, nStart + nEnd + 6 )
   END 
   
RETURN cText

FUNCTION zReplace( cCode, ... )

	LOCAL cExecute := "function __Inline()" + HB_OsNewLine() + cCode

RETURN Execute( cExecute, ... )
*/

FUNCTION Vista( cPrg, ... )

	LOCAL cFile := 'ap_GetEnv("HONEY_APP")' + '\src\view\' + cPrg 
	LOCAL cCode := MemoRead( cFile )
	
	Execute( cCode, ... )		

RETU NIL




FUNCTION InitQuery()
				
	STATIC hParameters 	:= { => }
	
	LOCAL cArgs 		:= AP_Args()
	LOCAL cPart
		
	FOR EACH cPart IN hb_ATokens( cArgs, "&" )
	
	   IF ( nI := At( "=", cPart ) ) > 0
		 hParameters[ lower(Left( cPart, nI - 1 )) ] := SubStr( cPart, nI + 1 ) 
	   ELSE
		 hParameters[ lower(cPart) ]:=  NIL 
	   ENDIF
	NEXT	

RETU hParameters

FUNCTION TGet( cKey, uDefault )

	LOCAL hParam := Initquery()
	LOCAL uValue

	zb_default( @cKey, '' )
	zb_default( @uDefault, '' )
	
	cKey := lower( cKey )
	
	IF hb_HHasKey( hParam, cKey )
		uValue := hParam[ cKey ]
	ELSE
		uValue := uDefault
	ENDIF

RETU uValue

FUNCTION TPost( cKey, uDefault )

	STATIC hPost 
	
	LOCAL uValue
    LOCAL n	   
   
    IF ( ValType( hPost ) <> 'H' )
	
		hPost := {=>}
   
		FOR n = 0 to AP_PostPairsCount() - 1
			hPost[ lower(AP_PostPairsKey( n )) ] := AP_PostPairsVal( n )
		NEXT
	
	ENDIF	

	zb_default( @cKey, '' )
	zb_default( @uDefault, '' )
	
	cKey := lower( cKey )
	
	IF hb_HHasKey( hPost, cKey )
		uValue := hPost[ cKey ]
	ELSE
		uValue := uDefault
	ENDIF

RETU uValue

/* HB_DEFAULT() no funciona bien */

FUNCTION ZB_Default( pVar, uValue )

	IF Valtype( pVar ) == 'U' 
		pVar := uValue
	ENDIF
	
RETU NIL


FUNCTION zLog( aInfo )

	LOCAL cFile := '/var/www/html/data/log.txt'
	LOCAL cLine := DToC( Date() ) + " " + Time() + " " + AP_USERIP() + ": "
	LOCAL hFile
	
   
	if ValType( aInfo ) != "A"
		aInfo = { hb_ValToStr( aInfo ) }
	endif   

    for n = 1 to Len( aInfo )
       cLine += hb_ValToStr( aInfo[ n ] ) + HB_OsNewLine()
    next
	
    cLine += CRLF

    if ! File( cFile )
       FClose( FCreate( cFile ) )
    endif

    if( ( hFile := FOpen( cFile, FO_WRITE ) ) != -1 )
      FSeek( hFile, 0, FS_END )
      FWrite( hFile, cLine, Len( cLine ) )
      FClose( hFile )
    endif

return nil