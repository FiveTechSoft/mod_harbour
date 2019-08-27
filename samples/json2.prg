/*
****************************************************************************
*   Aplicacion: Intercambio de datos JSON para mod_harbour 	 			      *
*       Fuente: json2.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 27-08-2019                                                 *
****************************************************************************
	Ejemplos JSON en https://www.sitepoint.com/10-example-json-files/
	Formats & syntax highlights JSON : https://github.com/yesmeck/jquery-jsonview
*/
function main()
	
	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Intercambio JSON</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-jsonview/1.2.3/jquery.jsonview.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-jsonview/1.2.3/jquery.jsonview.min.css"/>
		</head>
		<body>
		<div class="container">
		   <h1>Intercambio JSON</h1>
  			<div class="row">
			  <p class="lead">Ejemplo para comprobar como se puede compartir desde Javascript y desde harbour PRG, <b>un mismo formato JSON</b></p>
			  <p>Gracias al preprocesador, podemos definir JSON estándar dentro de nuestras aplicaciones, no sólo desde un array hash</p>
			  <p>Es curioso también observar como desde PRG podemos alimentar una variable Javascript</p>
			</div>


  			<div class="row">

    			<div class="col-sm-6">
    				<h3>Javascript</h3>
    				<div id="js-json"></div>
				</div>

    			<div class="col-sm-6">
    				<h3>PRG</h3>
    				<div id="prg-json"> 

	               <?prg 
	               	local aJson := hb_JSONDecode( LoadJSON() )
							return '<textarea rows="30" cols="60">'+hb_jsonEncode( aJson, .T. )+'</textarea>'
	               ?>

               </div>
				</div>
			</div>
		</div>
		<script>
			$(function() {

				var aJson = <?prg LoadJSON() ?>

				$("#js-json").JSONView(aJson);

			});
		</script>
		</body>
		</html>
	ENDTEXT

return NIL

//----------------------------------------------------------------------------------------//

function LoadJSON()

	local aJson

	#pragma __stream | aJson := %s
		[
			{
				"id": "59761c23b30d971669fb42ff",
				"isActive": true,
				"age": 36,
				"name": "Dunlap Hubbard",
				"gender": "male",
				"company": "CEDWARD",
				"email": "dunlaphubbard@cedward.com",
				"phone": "+1 (890) 543-2508",
				"address": "169 Rutledge Street, Konterra, Northern Mariana Islands, 8551"
			},
			{
				"id": "59761c233d8d0f92a6b0570d",
				"isActive": true,
				"age": 24,
				"name": "Kirsten Sellers",
				"gender": "female",
				"company": "EMERGENT",
				"email": "kirstensellers@emergent.com",
				"phone": "+1 (831) 564-2190",
				"address": "886 Gallatin Place, Fannett, Arkansas, 4656"
			},
			{
				"id": "59761c23fcb6254b1a06dad5",
				"isActive": true,
				"age": 30,
				"name": "Acosta Robbins",
				"gender": "male",
				"company": "ORGANICA",
				"email": "acostarobbins@organica.com",
				"phone": "+1 (882) 441-3367",
				"address": "697 Linden Boulevard, Sattley, Idaho, 1035"
			}
		]
	ENDTEXT

return aJson

//----------------------------------------------------------------------------------------//
