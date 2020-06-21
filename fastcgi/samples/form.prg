/*
	Harbour Module for Apache
	Autor: Lailton Fernando Mariano - <lailton@harbour.com.br>
	Sample: Simple login
*/

#xtranslate HTML => #pragma __text| AP_RPuts(%s)

memvar hForm

function Main()

	if loadForm()

		// here we can check the credential
		if getForm( "username" ) == "lailton" .and. getForm( "password" ) == "harbour"

			page_home()

			return nil
		else
			msgAlert( "User or password is not valid" )
		endif

		reload()

	else

		page_login()

	endif

return nil

function page_home()

	HTML
	<html>
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
			<title>Harbour for Web</title>
		</head>
		<body style="padding:100px;">

			<div class="jumbotron">
			<h1 class="display-4">Welcome to the future!</h1>
			<p class="lead">New mod_harbour for Apache!</p>
			<hr class="my-4">
			<p>Let's move on to the future together!</p>
			<p>It's harbour for Apache!</p>
			<a class="btn btn-primary btn-lg" href="form.prg" role="button">Back to login</a>
			</div>

		</body>
	</html
	ENDTEXT

return nil

function page_login()

	HTML
	<html>
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
			<title>Harbour for Web</title>
		</head>
		<body style="padding:100px;">

		<form method="post">
		<div class="form-group">
			<label for="inputUsername">Email address</label>
			<input type="text" class="form-control" id="inputUsername" placeholder="Enter Username" name="username">
			<small class="form-text text-muted">Use the username "lailton"</small>
		</div>
			<div class="form-group">
				<label for="inputPassword">Password</label>
				<input type="password" class="form-control" id="inputPassword" placeholder="Password" name="password">
				<small class="form-text text-muted">Password is "harbour"</small>
			</div>
			<button type="submit" class="btn btn-primary">Connect</button>
		</form>

		</body>
	</html
	ENDTEXT

return nil

function msgAlert( cMsg )
	?  "<script>alert('"+cMsg+"');</script>"
return nil

function reload()
	?  "<script>document.location.href = document.location.href;</script>"
return nil

function loadForm()
	public hForm := AP_PostPairs()
return len( hForm ) > 0

function getForm( cKey )

	local cVal := ""

	if hb_HHasKey( hForm, cKey )
		cVal := hForm[ cKey ]
	endif

return cVal
