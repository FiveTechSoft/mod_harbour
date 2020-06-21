/*
****************************************************************************
*   Aplicacion: Test jQuery DataTable con Ajax para mod_harbour            *
*       Fuente: test2.prg         		                                    *
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
			<title>Dynamic test columns &amp; data</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
			<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>Dynamic test columns &amp; data</h1>
    			<div class="col-sm-12">
					<table id="example" class="table table-striped table-bordered" style="width:100%"></table>
				<div>
			</div>
		</div>
			<script>
				
				$(document).ready( function () {

					$.ajax({
					    url:"data2.prg",
					    success: function(response){
			    			// debug	console.log(response);
			       		$("#example").DataTable({data:response.data, columns:response.columns});
					    }
					});
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil