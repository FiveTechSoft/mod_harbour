/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: data4.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 08-08-2019                                                 *
****************************************************************************
*/

// {% hb_SetEnv( "HB_INCLUDE", "/home/anto/harbour/include" ) %}
         
#include "hbsix.ch"

REQUEST DBFCDX
REQUEST DBFFPT

static _POST_

function main()

	local n
	local aRow
	local	hData := {=>}	
	local cPath := hb_GetEnv( "PRGPATH" )

   rddSetDefault( "DBFCDX" )
   SET AUTOPEN ON
	SET EXACT ON
	SET OPTIMIZE ON
  	SET DELETED ON                   
  	SET EPOCH TO 1950                
  	SET DATE FORMAT TO "dd-mm-yyyy"
  	Set( _SET_SOFTSEEK, .T. )

   USE ( cPath +"/../data/customer.dbf" ) ALIAS "data" SHARED
	
	_POST_ := PostPairs()
	hData['recordsTotal'] 		:= 10
	hData['recordsFiltered'] 	:= reccount()
	hData['searchValue']    	:= upper( _POST_['search[value]'] )
	hData['body']                   := AP_Body()
	hData['post']                   := _POST_
	hData['data'] 			:= {}

   if rlock()

   	SetIndex( cPath )
   	n := 0

		if empty( hData['searchValue'] )
   		data->( dbgotop() )
   	else
   		data->( dbseek(hData['searchValue'], .T.) )
   	endif

	   do while n < hData['recordsTotal'] .and. !data->( eof() )
			aRow := {}	
			aadd( aRow, data->id )
			aadd( aRow, rtrim(data->first) )
			aadd( aRow, rtrim(data->last) )
			aadd( aRow, data->salary )

			aadd( hData['data'], aRow )
			dbskip()
			n += 1
		enddo
	
      dbunlock()
   endif   

   CLOSE

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL

//----------------------------------------------------------------------------------------//

static function SetIndex( cPath )

	if !file( cPath +"/../data/customer.cdx")
	   INDEX ON field->Id 			  TAG "ID" 	TO ( cPath +"/../data/customer" )
	   INDEX ON upper(field->First) TAG "First" TO ( cPath +"/../data/customer" )
	else
		data->( dbsetindex(cPath +"/../data/customer") )
	endif

	data->( ordsetfocus('First') )

return .T.

//----------------------------------------------------------------------------------------//
// Variante funcion apache AP_PostPairs, con soporte codificacion UrlEncode
// Si se incorpora al mod, suprimir
//----------------------------------------------------------------------------------------//

static function PostPairs()

   local cPair, uPair, hPairs := {=>}

   local cBody := AP_Body()

   cBody := HB_URLDECODE( cBody )

   for each cPair in hb_ATokens( cBody, "&" )
      if ( uPair := At( "=", cPair ) ) > 0
            hb_HSet( hPairs, Left( cPair, uPair - 1 ), SubStr( cPair, uPair + 1 ) )
      endif
   next

return hPairs

//----------------------------------------------------------------------------------------//
