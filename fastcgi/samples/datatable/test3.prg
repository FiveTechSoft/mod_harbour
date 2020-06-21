/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: test3.prg                             		               *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 06-08-2019                                                 *
****************************************************************************
*/
function Main()

	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Server-side processing Test</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
			<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>Server-side processing Test</h1>
    			<div class="col-sm-12">
					<table id="example" class="table table-striped table-bordered" style="width:100%">
						<thead>
						   <tr>
						       <th>ID</th>
						       <th>First</th>
						       <th>Last</th>
						       <th>Salary</th>
						   </tr>
						</thead>
					</table>
				<div>
			</div>
		</div>
			<script>
				
				$(document).ready( function () {

		    		var table = $('#example').DataTable({
						"ajax": {
							"url": "data3.prg",
							"type": "POST"
						},
						"processing": true,
						"serverSide": true,
						"searching": false,
						"lengthChange": false
		    		});
		    		// debug, controlando eventos :))
		    		// (e,s,j)=> event, settings, json
		    		table.on( 'xhr', function(e,s,j) {
		    			console.log( 'Returned data: ', j );
	    			});
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil