/*
****************************************************************************
*   Aplicacion: Diseñador de formularios para mod_harbour            		*
*       Fuente: test2.prg                             		               *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 16-08-2019                                                 *
****************************************************************************
* Introduccion al ecosistema formeo  
* https://draggable.github.io/formeo/
****************************************************************************
*/
function Main()

	TEMPLATE
	<!DOCTYPE html>
	<html>
	  	<head>
			<meta charset="utf-8" />
			<meta http-equiv="X-UA-Compatible" content="chrome=1" />
			<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"/>

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>

			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
			<link rel="stylesheet" type="text/css" href="https://draggable.github.io/formeo/assets/css/demo.min.css" />

			<title>Viewer Forms Resource Workshop</title>
	  	</head>
		<body>

			<div class="container">
				<div class="row">
					<h1>Viewer Forms Resource Workshop</h1>
					<hr>
	    			<div class="col-sm-12">
						<table id="example" class="table table-striped table-bordered" style="width:100%"></table>
					<div>
				</div>

				<!-- Modal -->
				<div class="modal fade" id="form-popup" tabindex="-1" role="dialog" aria-labelledby="form-popup-label" aria-hidden="true">
				  <div class="modal-dialog" role="document">
				    <div class="modal-content">
				      <div class="modal-header">
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				        </button>
				        <h3 class="modal-title" id="form-popup-label">Preview form</h3>
				      </div>
				      <div class="modal-body">
				        <div id="form-render"></div>
				      </div>
				      <div class="modal-footer">
				      </div>
				    </div>
				  </div>
				</div>


			</div>
			<script src="https://draggable.github.io/formeo/assets/js/formeo.min.js"></script>
			<script>

				function Render(mode, response) { 

					var oForm;

					if (mode) {
						oForm= new FormeoRenderer({renderContainer:'#form-render'}); 
						oForm.render(response.form);
						$('#form-popup').modal('show');

					} else {
						
						if (response.html) {

							var w = window.open();
							$(w.document.body).html(response.html);

						} else {

							console.log("No existe formulario en HTML");
						}
					}
				}

				function CreateTable(response) {
					
					$("#example").DataTable({
						data:response.data, 
						columns:response.columns,
						"searching": false,
						"paging": false
					});
				}

				function Preview(id, mode) {

					$.getJSON( "data3.prg", {id:id}, function(response, status) {
						// debug
						console.log(response, status);
						
						if (status=="success") {

							// Renderizar formulario
							Render(mode, response);
						}
					});
				}

				// Punto de entrada
				$(document).ready( function () {

					$.ajax({
						url:"data3.prg",
						type:'POST',
						success: function(response){
			    			// debug	
			    			console.log(response);
			    			CreateTable(response);

			       		// Capturar evento click para mostrar formulario seleccionado
							$('.viewPopup').on( 'click', function(e) {
								// debug console.log( e.target.id );
								Preview(e.target.id, true);
							});

			       		// Capturar evento click para mostrar formulario seleccionado
							$('.viewPage').on( 'click', function(e) {
								// debug console.log( e.target.id );
								Preview(e.target.id, false);
							});
						}
					});
				});

			</script>
		</body>
	</html>
	ENDTEXT

return nil
