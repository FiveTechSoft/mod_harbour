/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: data1.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 06-08-2019                                                 *
****************************************************************************
*/
function main()

	local	hData := {=>}	
	local hItem

   USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED
	
	hData['data'] := {}

   if rlock()

	   do while !eof()
			hItem := {=>}	
			hItem['id'] 	 	:= data->id
			hItem['first']  	:= rtrim(data->first)
			hItem['last'] 	 	:= rtrim(data->last)
			hItem['street'] 	:= rtrim(data->street)
			hItem['city']   	:= rtrim(data->city)
			hItem['state']  	:= rtrim(data->state)
			hItem['zip']  		:= rtrim(data->zip)
			hItem['hiredate'] := data->hiredate
			hItem['married']  := data->married
			hItem['age']  		:= data->age
			hItem['salary']  	:= data->salary

			aadd( hData['data'], hItem )
			dbskip()
		enddo
	
      dbunlock()
   endif   

	CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL