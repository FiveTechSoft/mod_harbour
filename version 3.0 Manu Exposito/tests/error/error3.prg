procedure main()

	mh_setErrorBlock( { | hError | MyErrorPlus( hError ) } )
	
	? a + 5
	
return 

procedure MyErrorPlus( hError )

	local cHtml := ''
    local n, aPair    

	BLOCKS TO cHtml 

		<style>
		
			body { background-color: lightgray; }
			
			table { box-shadow: 2px 2px 2px black; }
			
			table, th, td {
				border-collapse: collapse;
				padding: 5px;
				font-family: tahoma;
			}
			th, td {
				border-bottom: 1px solid #ddd;
			}			
			th {
			  background-color: #4caf50;
			  color: white;
			}	
			
			tr:hover { background-color: yellow; }
			
			.title {
				width:100%;
				height:70px;
			}
			
			.title_error {
				margin-left: 20px;
				float: left;
				margin-top: 20px;
				font-size: 26px;
				font-family: sans-serif;
				font-weight: bold;
			}
			
			.logo {
				float:left;
				width: 100px;
			}
			
			.description {
				font-weight: bold;
				background-color: white;
			}
			
			.value {				
				background-color: white;
			}			
			
		</style>
		
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<title>ErrorSys</title>										
			<link rel="shortcut icon" type="image/png" href="images/favicon.ico"/>
		</head>		
		
		<div class="title">
			<img class="logo" src="images/modharbour_mini.png"></img>
			<p class="title_error">My Error System</p>			
		</div>
		
		<hr>		
		
		<div>
			<table>
				<tr>
					<th>Description</th>
					<th>Value</th>			
				</tr>	
	ENDTEXT 
		
	cHtml += '<tr><td class="description">Description</td><td class="value">' + hError[ 'description' ] + '</td><tr>'
	cHtml += '<tr><td class="description">Operation</td><td class="value">' + hError[ 'operation' ] + '</td><tr>'

	BLOCKS TO cHtml 

				</table>
			</div>		
			
			<h3>Send mail to administrator: <a href="mailto:admin@mh.com">admin@mh.net</a></h3>
		</html>
		
	ENDTEXT 	
	
	?? cHtml 	  

return 
