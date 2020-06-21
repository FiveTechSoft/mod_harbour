function Main()

	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>DBF table structure</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
			<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>DBF table structure</h1>
    			<div class="col-sm-12">
					<table id="example" class="table table-striped table-bordered" style="width:100%"></table>
				<div>
			</div>
		</div>
			<script>
				
				$(document).ready( function () {

					$.ajax({
					    url:"datastruct.prg",
					    success: function(response){
			       		$("#example").DataTable({data:response.data, columns:response.columns, ordering:false });
					    }
					});
				});

			</script>
		</body>
		</html>
	ENDTEXT

return nil