/*
****************************************************************************
*   Aplicacion: Test para crear array Javascript desde Harbour             *
*       Fuente: arrays.prg                                                 *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 28-08-2019                                                 *
****************************************************************************
*/
function Main()

	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Create Javascript array from Harbour</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>Crear array Javascript desde Harbour</h1>
   			<p class="lead">Create Javascript array from Harbour</p>
    			<div class="col-sm-12">

				<form role="form">
				   <div class="form-group">
				      <label>Data select from Harbour items</label>
				      <select id="combobox" class="form-control"></select>
				   </div>
				</form>

				<div>
			</div>
		</div>
			<script>
				
				$(document).ready( function () {

		    		var aList = <?prg LoadArrayFromHarbour() ?>
					
					console.log(aList);
					combobox  = document.getElementById( 'combobox' );

					for( n in aList ) {
					 
						combobox.add( new Option( aList[n] ) );
					};
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil

//----------------------------------------------------------------------------------------//

function LoadArrayFromHarbour()

	local cStr 	:= ""
	local aItems:= { 1,2,3,4,5, {'a','b','c', day(date()) } }
	local aList	:= { "Sunday", date(),  175.25, .T., aItems }
	
	cStr := ArrayToList( aList )
	cStr := "["+ cStr +"]"

return cStr

//----------------------------------------------------------------------------------------//

static function ArrayToList( aList, cSeparator )

   local n
   local cStr 	:= ""
   local nLen 	:= len( aList )

   hb_default( @cSeparator, "," )

   for n := 1 to nLen

		switch valtype( aList[n] )
			case 'C' 
				cStr += '"'+ aList[n] +'"' 
				EXIT
			case 'N' 
				cStr += ltrim( str(aList[n]) )
				EXIT
			case 'D' 
				cStr += '"'+ dtoc( aList[n] ) +'"' 
				EXIT
			case 'L' 
				cStr += If( aList[n], 'true', 'false' ) 
				EXIT
			case 'A' 
				cStr += '['+ ArrayToList( aList[n], cSeparator ) +']'
				EXIT
			otherwise
				cStr += valtochar( aList[n] )
		end

      if n < nLen
         cStr += cSeparator
      endif
   next

return cStr

//----------------------------------------------------------------------------------------//
