/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: test5.prg                             		               *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 09-08-2019                                                 *
****************************************************************************
* Introduccion al plugin jquery-jsonform  
* https://github.com/jsonform/jsonform
****************************************************************************
*/
function Main()

	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Export data &amp; events</title>

			<!-- Framework jQuery -->
			<script type="text/javascript" src="jsonform/deps/jquery.min.js"></script>

			<!-- Dependences JsonForm -->
			<script type="text/javascript" src="jsonform/deps/underscore.js"></script>
			<script type="text/javascript" src="jsonform/deps/opt/jsv.js"></script>

			<!-- Plugin JsonForm -->
			<script type="text/javascript" src="jsonform/lib/jsonform.js"></script>
			<link rel="stylesheet" style="text/css" href="jsonform/deps/opt/bootstrap.css" />

			<style>
				.jsonform-required > label:after {
				  content: ' *';
				  color: red;
				}

				.jsonform-hasrequired:after {
				  content: '* Required field';
				  display: block;
				  color: red;
				  padding-top: 1em;
				}
			</style>

		</head>
		<body>
		<div class="container">
			<h1>Basic sample with JSON Form</h1>
			<p class="lead">Ejemplo básico con JSON Form</p>
  			<div class="row">
    			<div class="col-md-6 col-md-offset-3">
					<form id="form"></form>
					<div id="res" class="alert"></div>
				<div>
			</div>
		</div>
			<script>

				$.getJSON( "data1.prg", function(response, status) {
					// debug
					console.log(response, status);
					
					if (status=="success") {

						// Controlar evento para enviar formulario
						response.data.onSubmitValid = function(values) {
							console.log(values);
						}	

						// Renderizar formulario
						$('#form').jsonForm(response.data);
					}
	
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil