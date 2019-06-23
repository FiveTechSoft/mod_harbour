//#define __LOG__

#ifdef __LOG__
	#xcommand log <cText> => TLog( <cText> )	//	Tracear el sistema
 #else
	#xcommand log <cText> =>
#endif

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
