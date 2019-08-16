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
		    <h1>FRW. Forms Resource Workshop</h1>

			<!-- Modal -->
			<div class="modal fade" id="form-popup" tabindex="-1" role="dialog" aria-labelledby="form-popup-label" aria-hidden="true">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			        <h3 class="modal-title" id="form-popup-label">Modal title</h3>
			      </div>
			      <div class="modal-body">
			        <div id="form-render"></div>
			      </div>
			      <div class="modal-footer">
			      </div>
			    </div>
			  </div>
			</div>

			<div id="formeo-editor"></div>

		    <script src="https://draggable.github.io/formeo/assets/js/formeo.min.js"></script>
		    <script>
		    var data;
		    var formeo = new FormeoEditor({
				editorContainer: '#formeo-editor',
				svgSprite: 'https://draggable.github.io/formeo/assets/img/formeo-sprite.svg',
				debug:false,
				sessionStorage: false,

				events: {
					onSave: (evt) => {
						console.log(this.formeo.formData);

						var oForm = new FormeoRenderer({renderContainer: '#form-render'}); 
						FormRender(oForm, this.formeo.formData);
						$('#form-popup').modal('show');
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
							label: 'Price'
						},
						meta: {
							group: 'common',
							icon: 'text-input',
							id: 'price-input'
						}
					}]
				}
			});

			function FormRender( oForm, formData ) { 
				oForm.render(formData);
			}
		   
		    </script>
		  </body>
		</html>
	ENDTEXT

return nil
