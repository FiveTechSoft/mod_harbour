function main()
	
	? 'Now is: ', hb_datetime(), '<hr>'

	SetCookie( 'MyCookie', 'This Cookie was born ' + time() + ' Only live 60 seconds...', 60 )
	
	? 'Cookie created !'

retu nil


//	Incluido en el módulo session.prg

FUNCTION SetCookie( cName, cValue, nSecs, cPath, cDomain, lHttps, lOnlyHttp ) 

	LOCAL cCookie := ''
	
	//	Validacion de parámetros

		zb_default( @cName		, '' )
		zb_default( @cValue		, '' )
		zb_default( @nSecs		, 3600 )		//	Session Expired in Seconds 60 * 60 = 3600
		zb_default( @cPath		, '/' )
		zb_default( @cDomain	, '' )
		zb_default( @lHttps		, .F. )
		zb_default( @lOnlyHttp	, .F. )	
	
	//	Montamos la cookie
	
		cCookie += cName + '=' + cValue + ';'
		cCookie += 'expires=' + CookieExpire( nSecs ) + ';'
		cCookie += 'path=' + cPath + ';'
		cCookie += 'domain=' + cDomain + ';'
		
	//	Pendiente valores logicos de https y OnlyHttp
	

	//	Envio de la Cookie
	
		AP_HeadersOutSet( "Set-Cookie", cCookie )

RETU NIL

/*	----------------------------------------------------------------

	CookieExpire( nSecs ) Creará el formato de tiempo para la cookie
	
		Este formato sera: 'Sun, 09 Jun 2019 16:14:00'

--------------------------------------------------------------------- 	*/
function CookieExpire( nSecs )

    LOCAL tNow		:= hb_datetime()	
	LOCAL tExpire						//	TimeStampp 
	LOCAL cExpire 					//	TimeStamp to String
	
	zb_default( @nSecs, 60 )		//	60 seconds or test
   
    tExpire 	:= hb_ntot( (hb_tton(tNow) * 86400 - hb_utcoffset() + nSecs ) / 86400)

    cExpire 	:= cdow( tExpire ) + ', ' 
	cExpire 	+= alltrim(str(day( hb_TtoD( tExpire )))) + ' ' + cmonth( tExpire ) + ' ' + alltrim(str(year( hb_TtoD( tExpire )))) + ' ' 
    cExpire 	+= alltrim(str( hb_Hour( tExpire ))) + ':' + alltrim(str(hb_Minute( tExpire ))) + ':' + alltrim(str(hb_Sec( tExpire )))

return cExpire


/*	---------------------------------------------------------------------
	HB_DEFAULT() no funciona bien. De momento parcheado con zb_Default()
	
	DEFAULT tampoco funciona
	
	#xcommand DEFAULT <uVar1> := <uVal1> ;
				   [, <uVarN> := <uValN> ] => ;
					  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
					[ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]			
------------------------------------------------------------------------- 	*/

FUNCTION ZB_Default( pVar, uValue )

	IF Valtype( pVar ) == 'U' 
		pVar := uValue
	ENDIF
	
RETU NIL
