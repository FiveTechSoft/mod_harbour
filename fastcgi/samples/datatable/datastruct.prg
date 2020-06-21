function Main()

   	local hData := {=>}	

	hData[ 'data' ]    = {}
	hData[ 'columns' ] = {}
   
   	USE ( hb_GetEnv( "PRGPATH" ) + "/../data/customer.dbf" ) ALIAS "data" SHARED
	AEval( DbStruct(), { | a | AAdd( hData[ "data" ], a ) } )
    USE

	AEval( { "FieldName", "Type", "Len", "Dec" },;
	       { | c | AAdd( hData[ "columns" ], { "title" => c } ) } )

	AP_SetContentType( "application/json" )
	?? hb_jsonEncode( hData, .T. )

return NIL