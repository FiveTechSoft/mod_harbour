/*
****************************************************************************
*   Aplicacion: Diseñador de formularios para mod_harbour                	*
*       Fuente: data2.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 20-08-2019                                                 *
****************************************************************************
*/
function main()

   local hData := {=>}
   local hPost

   hb_jsondecode( AP_Body(), @hPost )
   hData['post'] := hPost

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/jsonform.dbf" ) ALIAS "data" SHARED

   if rlock()
      dbappend()
      data->name     := hPost['name']
      data->origin   := AP_HeadersIn()['Origin']
      data->date     := date()
      data->time     := time()
      data->json     := hb_jsonEncode( hPost['form'] )

      dbunlock()
      hData['error']  := .F.
   else
      hData['error']  := .T.
      hData['errmsg'] := "Error data"
   endif 

   CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL

//----------------------------------------------------------------------------------------//

