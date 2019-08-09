/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: test5.prg                             		               *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 09-08-2019                                                 *
****************************************************************************
* Introduccion al plugin jquery-confirm  
* https://craftpip.github.io/jquery-confirm/
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
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<!-- Plugin jQuery Confirm -->
			<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
			<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

			<!-- Plugin Datatable -->
			<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>

			<!-- libs para exportar a copy, csv, excel, pdf, print -->
			<script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js"></script>
			<script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
			<script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js"></script>
			<script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js"></script>

			<!-- Estilos -->
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
			<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css"/>
			<style>
				.dt-buttons 		{ text-align: right; }
				.dt-button  		{ width:100px; height:30px; border:0; }
				.dt-button:hover  { background-color: #76b3f5; }
			</style>
		</head>
		<body>
		<div class="container">
			<h1>Export data plugin &amp; buttons control events</h1>
			<p class="lead">Exportar a distintos formatos y control de eventos en botones</p>
  			<div class="row">
    			<div class="col-sm-12">
					<table id="example" class="table table-striped table-bordered" style="width:100%">
						<thead>
						   <tr> 
						       <th>ID</th>
						       <th>First</th>
						       <th>Last</th>
						       <th>Salary</th>
						       <th><button id="new" class="btn btn-success btn-block">New</button></th>
						   </tr>
						</thead>
					</table>
				<div>
			</div>
		</div>
			<script>
				
				$(document).ready( function () {

		    		var table = $('#example').DataTable({
			        	dom: 'Bfrtip',
						buttons: [
							'copy', 'csv', 'excel', 'pdf', 'print'
						],
						ajax: "data5.prg",
						searching: false,
						lengthChange: false,
			         columnDefs: [
			         	{
				            targets: -1,
								orderable: false,
				            data: null,
				            width:"130px",
				            align:"center",
				            defaultContent: "<button name=edit class=btn btn-primary>Edit</button> <button name=delete class=btn btn-primary>Delete</button>",
			         	},
			         	{
				            targets: [2,3],
								orderable: false
			         	}
			         ]
		    		});
		    		
					$('#new').on( 'click', function( e ){
						$.alert( "New" );
					});

					$('#example tbody').on( 'click', 'button', function( e ){

						// debug	console.log(e);

						// Boton edit o delete ?
						var action = e.target.name;

						// Recuperar fila
						var data = table.row( $(this).parents('tr') ).data();

						// Recuperar ID
						var id=data[0];

						// Popup dialog
						$.confirm({
							columnClass: 'col-md-8',
							buttons: {
								Aceptar: function () {
									$.alert('Confirmed!');
								},
								Cancelar: function () {
									//$.alert('Canceled!');
								}
							},
							content: function () {
								var self = this;

								// Devolver llamada de nuevo a data5.prg y mostrar resultado
								return $.ajax({
									contentType: 'application/json; charset=utf-8',
								   url: 'data5.prg',
								   type: 'post',
									data: {id:id, action:action}

								}).done(function (response) {
								   self.setContent( JSON.stringify(response.data) );
								   self.setTitle("Record "+ id);

								}).fail(function(){
								   self.setContent('Fail !');
								});
							}
						});
						// End Popup dialog
					});
					// End $('#example tbody')
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil