#define PATH_DATA 		HB_GetEnv( "PRGPATH" ) + '/data/'

//	Recibiremos via GET 3 parámetros	----------------------------------------
//	search	-> query, cadena,... que marca algo a filtrar. Blanco por defecto
//	offset -> posicion relativa al filtro, al indice. Inicial es 0
//	limit 	-> máximo numero de registros 
//	------------------------------------------------------------------------

function Main()

	local dat 			:= {=>}
	local aRows 		:= {}
	local hParam		:= AP_GetPairs()
	local cDbf			:= PATH_DATA + hParam[ 'tabla' ] + '.dbf'	
	local cCdx			:= PATH_DATA + hParam[ 'tabla' ] + '.cdx'	
	local cSearch 		:= hParam[ 'search' ] 
	local nOffset 		:= val( hParam[ 'offset' ] )
	local nLimit 		:= val( hParam[ 'limit' ] )
	local n 		   	:= 0, m
	local nTotal 
	
	nOffset := IF( nOffset == 0, 1, nOffset )	
	
	USE ( cDbf ) SHARED NEW VIA 'DBFCDX'

	if File( cCdx )
	   SET INDEX TO ( cCdx )
	else
		if ! Empty( cSearch )
			SET FILTER TO cSearch
		endif		
	endif

	cAlias = Alias()
	( cAlias )->( DbGoTop() )
	
	// ( cAlias )->( OrdSetFocus( 'FIRST' ) )

	if ! Empty( cSearch )
	   ( cAlias )->( OrdScope( 0, cSearch ) )
	   ( cAlias )->( OrdScope( 1, cSearch  ) )
	endif	
		
	if ! Empty( nOffset )
	   ( cAlias )->( OrdKeyGoto( nOffset ) )
	endif	

	while n < nLimit .and. ( cAlias )->( ! Eof() ) 
		n++	
		AAdd( aRows, { 'keyno'  => ( cAlias )->( OrdKeyNo() ),;
							'_recno' => ( cAlias )->( Recno() ) } )
	   for m = 1 to ( cAlias )->( FCount() )
			hb_HSet( ATail( aRows ), ( cAlias )->( FieldName( m ) ), ( cAlias )->( FieldGet( m ) ) )
		next	

		( cAlias )->( DbSkip() )			
	end			
	
	//	-----------------------------------------------------
	//	Debemos devolver un hash con 3 keys
	//	total				-> Total registros filtrados, no paginados
	//	totalNotFiltered 	-> Total registros tabla
	//	rows				-> Array de hashes de cada registro 
	//	-----------------------------------------------------
	
	COUNT TO nTotal

	dat[ 'total' ] 				:= (cAlias)->( ordKeyCount() )	
	dat[ 'totalNotFiltered' ] 	:= nTotal
	dat[ 'rows' ] 				   := aRows

	AP_SetContentType( "application/json" )
	
	?? hb_jsonEncode( dat ) 

return nil