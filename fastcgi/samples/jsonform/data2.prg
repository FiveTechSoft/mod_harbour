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
   hData['post']  := hPost
   hData['error'] := .F.

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/jsonform.dbf" ) ALIAS "data" SHARED

   if rlock()
      dbappend()
      data->name     := hPost['name']
      data->origin   := AP_HeadersIn()['Origin']
      data->date     := date()
      data->time     := time()
      data->json     := hb_jsonEncode( hPost['form'] )
      data->html     := CreateHtmlDocument( data->name, hPost['html'] )

      dbunlock()
   else
      hData['error']  := .T.
      hData['errmsg'] := "Error data"
   endif 

   CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL

//----------------------------------------------------------------------------------------//

static function CreateHtmlDocument( cName, cHtml )

   local cDoc := ""
   cDoc += '<!DOCTYPE html>'
   cDoc += '   <html>'
   cDoc += '      <head>'
   cDoc += '         <meta charset="utf-8" />'
   cDoc += '         <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"/>'
   cDoc += '         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>'
   cDoc += '         <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>'
   cDoc += '         <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>'
   cDoc += '         <script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>'
   cDoc += '         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">'
   cDoc += '         <link rel="stylesheet" type="text/css" href="https://draggable.github.io/formeo/assets/css/demo.min.css" />'
   cDoc += '         <title>'+ cName +'</title>'
   cDoc += '      </head>'
   cDoc += '      <body>'
   cDoc += '         <div class="container">'
   cDoc += '            <div class="row">'
   cDoc += '               <h1>'+ cName + '</h1>'
   cDoc += '               <hr>'
   cDoc += '               <div class="col-sm-12">'
   cDoc +=                    cHtml
   cDoc += '               <div>'
   cDoc += '            </div>'
   cDoc += '         </div>'
   cDoc += '      </body>'
   cDoc += '   </html>'

   cDoc := alltrim( cDoc )

return( cDoc )

//----------------------------------------------------------------------------------------//
