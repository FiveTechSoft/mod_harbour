/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: data3.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 07-08-2019                                                 *
* 	Inspiracion: 																				*
*	https://makitweb.com/datatables-ajax-pagination-with-search-and-sort-php*
****************************************************************************
*/
function main()

	local	hData := {=>}	
	local aRow
	local n, nStart

   USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED
	
	hData['method'] 				:= AP_Method()
	hData['hPost'] 				:= AP_PostPairs()
	hData['draw'] 					:= hData['hPost']['draw']
	hData['start'] 				:= hData['hPost']['start']
	hData['recordsTotal'] 		:= 10
	hData['recordsFiltered'] 	:= reccount()
	hData['data'] 					:= {}

   if rlock()

   	n := 0
   	nStart := val( hData['start'] ) +1
   	dbgoto(nStart)

	   do while n < hData['recordsTotal'] .and. !eof()
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