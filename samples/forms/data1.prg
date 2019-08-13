/*
****************************************************************************
*   Aplicacion: Test jQuery jsonForm para mod_harbour             			*
*       Fuente: data1.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 12-08-2019                                                 *
****************************************************************************
*/

static hData := {=>}	

function main()
	
	local aRow
	local n, nStart, nLen

	SET DATE FORMAT TO "yyyy-mm-dd"

   USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED

	hData['data'] := {=>}

	// Objeto que describe el modelo de datos
	// Object that describes the data model
	hData['data']['schema'] := {=>}

	// Matriz que describe la disposición del formulario y valores
	// Array that describes the layout of the form values
	hData['data']['form'] 	:= {}

   if rlock()
   	
		nStart := 100
		dbgoto( nStart )

		aRow := {}
		nLen := data->( fcount() )

		for n:= 7 to 15 //nLen
			CreateField( n )
		next

		aadd( hData['data']['form'], {'type'=>"submit", 'title'=>"Guardar"} )

      dbunlock()
   endif   

	CLOSE 

	AP_SetContentType( "application/json" )

	?? hb_jsonEncode( hData, .T. )	// T=pretty

return NIL

//----------------------------------------------------------------------------------------//

static function CreateField( nPos )
	
	local hHash  := {=>}
	local	cField := fieldname( nPos )
	local uValue := fieldget( nPos )
	local cType  := valtype( uValue )

	hHash['title'] := cField

	switch cType
	
		case "C"
		case "M"
			hHash['type'] 		:= "string"
			hHash['required'] := "jsonform-required"
			hHash['maxLength'] := 20
			
			if len(uValue) > 20
				hHash['readOnly'] := .T.
				hHash['required'] := .F.
			endif
			EXIT

		case "N"
			hHash['type'] 		:= "number"
			EXIT

		case "D"
			hHash['type'] 		:= "date"
			EXIT

		case "L"
			hHash['type'] 		:= "boolean"
			EXIT

		otherwise
			hHash['type'] 		:= "string"
	end

	hData['data']['schema'][cField] := hHash

	aadd( hData['data']['form'], ;
		{'key'=>cField, 'value'=>valtochar(uValue)} ;
	)

return hHash 

//----------------------------------------------------------------------------------------//
