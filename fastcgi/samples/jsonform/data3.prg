/*
****************************************************************************
*   Aplicacion: Diseñador de formularios para mod_harbour                	*
*       Fuente: data3.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 20-08-2019                                                 *
****************************************************************************
*/
function main()

   local hData := {=>}
   local hForm
   local cHeader
   local aHeaders, aRow

   SET EPOCH TO 1950                
   SET DATE FORMAT TO "dd-mm-yyyy"

   USE ( hb_GetEnv( "PRGPATH" ) + "/data/jsonform.dbf" ) ALIAS "data" SHARED

   hData := {=>}  
   hData['data']    := {}
   hData['columns'] := {}
   hData['method']  := AP_Method()

   if rlock()

      if hData['method'] == "POST"
         // rows
         do while !eof()
            aRow := {}  
            aadd( aRow, data->name )
            aadd( aRow, rtrim(data->origin) )
            aadd( aRow, dtoc(data->date) )
            aadd( aRow, data->time )
            aadd( aRow, ;
               '<a href="#" class="viewPopup" id="'+ltrim(str(recno()))+'">popup</a> | '+;
               '<a href="#" class="viewPage" id="'+ltrim(str(recno()))+'">new page</a>' ;
            )
            aadd( hData['data'], aRow )
            dbskip()
         enddo
      
         // cols
         aHeaders := {'name','user IP','date','time','preview'}

         for each cHeader in aHeaders
            hItem := {=>}  
            hItem['title'] := upper( cHeader )
            aadd( hData['columns'], hItem )
         next
         hData['error']  := .F.
      
      elseif hData['method'] == "GET"

         // Recuperar id recibido ($_GET)
         hData['id'] := LoadGet()['id']

         // Ir al registro
         dbgoto( val(hData['id']) )

         // Cargar datos del registro
         hb_jsondecode( data->json, @hForm )
         hData['name'] := data->name
         hData['form'] := hForm
         hData['html'] := data->html

         dbunlock()
         hData['error']  := .F.

      endif

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
// By @Carles->Charly thanks!
//----------------------------------------------------------------------------------------//

function LoadGet() 

   local cPart 
   local cArgs := AP_Args()
   local hGet  := {=>}
   
   for each cPart in hb_ATokens( cArgs, "&" )
   
      if ( nI := At( "=", cPart ) ) > 0
         hGet[ lower(Left( cPart, nI - 1 )) ] := Alltrim(SubStr( cPart, nI + 1 ))
      else
         hGet[ lower(cPart) ] :=  ''
      endif
      
   next                

return hGet

//----------------------------------------------------------------------------------------//
