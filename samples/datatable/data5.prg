/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: data5.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 09-08-2019                                                 *
****************************************************************************
* Demostracion de un script multi-funcion, dependiendo del método 
* de llamada y accion requerida
* 		GET, muestra una lista de registros
* 		POST, si la accion es "EDIT", devuelve el registro a editar segun ID
* 		POST, si la accion es "DELETE", simula borrar registro segun ID
****************************************************************************
*/
function main()
	
	local	hData := {=>}	
	local aRow, aPost
	local n, nStart, nLen
	local cAction

   USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED
	
	hData['method'] 				:= AP_Method()
	hData['recordsTotal'] 		:= 40
	hData['recordsFiltered'] 	:= 8
	hData['data'] 					:= {}

   if rlock()
   	
   	if hData['method'] == "GET"
	   	n := 0
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

		elseif hData['method'] == "POST"

			aPost   := AP_PostPairs()
			nStart  := val( aPost['id'] )
			cAction := upper( aPost['action'] )

			if cAction == "EDIT"

				dbgoto( nStart )

				aRow := {}
				nLen := data->( fcount() )

				for n:= 1 to nLen
					aadd( aRow, data->( fieldget(n) ) )
				next

			elseif cAction == "DELETE"
				// Borrar registro segun ID
				dbgoto( nStart )
				/* dbdelete( nStart ) */
				aRow := {"El registro ha sido borrado (simulado)", nStart}
			endif

			aadd( hData['data'], aRow )

		endif

      dbunlock()
   endif   

	CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL

//----------------------------------------------------------------------------------------//
