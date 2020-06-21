/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: data2.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 07-08-2019                                                 *
****************************************************************************
*/
function main()

	local	hData, hItem	
	local aRow, aHeaders
	local cHeader

   USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED
	
	hData := {=>}	
	hData['data'] 	  := {}
	hData['columns'] := {}

   if rlock()

   	// rows
	   do while !eof()
			aRow := {}	
			aadd( aRow, data->id )
			aadd( aRow, rtrim(data->first) )
			aadd( aRow, rtrim(data->last) )
			aadd( aRow, rtrim(data->street) )
			aadd( aRow, rtrim(data->city) )
			aadd( aRow, rtrim(data->state) )
			aadd( aRow, rtrim(data->zip) )
			aadd( aRow, data->hiredate )
			aadd( aRow, data->married )
			aadd( aRow, data->age )
			aadd( aRow, data->salary )

			aadd( hData['data'], aRow )
			dbskip()
		enddo
	
		// cols
  		aHeaders := {'id','first','last','street','city','state','zip','hiredate','married','age','salary'}

		for each cHeader in aHeaders
			hItem := {=>}	
  			hItem['title'] := upper( cHeader )
  			aadd( hData['columns'], hItem )
  		next

      dbunlock()

   endif   

	CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .F. )	// F=compact

return NIL