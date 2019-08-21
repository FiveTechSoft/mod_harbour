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
		  
			<link rel="stylesheet" type="text/css" href="https://draggable.github.io/formeo/assets/css/demo.min.css" />

			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

		    <title>FRW. Forms Resource Workshop</title>
		  </head>
		  <body>

			<div class="container">
				<div class="row">
					<h1>FRW. Forms Resource Workshop</h1>
					<hr>
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
				        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				      </div>
				    </div>
				  </div>
				</div>

				<div id="formeo-editor"></div>
				<div>
					<button type="button" class="btn btn-primary" onclick="Preview()">Preview</button>
				</div>
		   </div>
		   
		    <script src="https://draggable.github.io/formeo/assets/js/formeo.min.js"></script>
		    <script>

				function Render() { 
					var oForm = new FormeoRenderer({renderContainer: '#form-render'}); 
					oForm.render(formeo.formData);
					return $('#form-render').html();
				}

				function Preview() { 
					Render()
					$('#form-popup').modal('show');
				}

				function SaveForm(formName) {
					var formData = {
						'name': formName,
						'form': formeo.formData,
						'html': Render()
					};
					
					$.ajax({
						url: 'data2.prg',
						method: 'POST',
						data: JSON.stringify( formData )

					}).done(function(response) {
						console.log(response);

					}).fail(function(response) {
					   console.log(response);
					});
				}
		    
				var formeo = new FormeoEditor({
					editorContainer: '#formeo-editor',
					svgSprite: 'https://draggable.github.io/formeo/assets/img/formeo-sprite.svg',
					debug:false,
					sessionStorage: false,

					events: {
						onSave: (evt) => {

							var formName = prompt("Nombre del formulario a guardar ?");

							if (formName!==null) {
								SaveForm(formName);
							}
						}
					},

					controls: {
						elements: [{
							tag: 'input',
							attrs: {
								type: 'number',
								className: 'form-control'
							},
							config: {
								label: 'Precio'
							},
							meta: {
								group: 'common',
								icon: 'text-input',
								id: 'price-input'
							}
						}]
					}
				});

		    </script>
		  </body>
		</html>
	ENDTEXT

return nil
