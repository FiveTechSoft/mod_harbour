/*
****************************************************************************
*   Aplicacion: Test basico para comprobar soporte CURL mod_harbour 	      *
*       Fuente: test1.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 12-08-2019                                                 *
****************************************************************************
1) Conecta a API publica http://jsonplaceholder.typicode.com/users
2) Obtiene lista de usuarios (users) en un buffer
3) Recupera el objeto codificado JSON en aData
4) Devuelve elemento 1 de la lista 
****************************************************************************
// Necesario -de momento- para que encuentre el fichero include en servidor
{% hb_SetEnv( "HB_INCLUDE", If( "Linux" $ OS(), "/home/anto/harbour/include", If( "Windows" $ OS(), "c:\harbour\include", "/Users/anto/harbour/include" ) ) ) %}
//
*/
//#include "hbcurl.ch"
#define HB_CURLOPT_URL                        2
#define HB_CURLOPT_DL_BUFF_SETUP              1008

function main()
	
	TEMPLATE
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Basic test CURL mod_harbour</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>Basic test CURL mod_harbour</h1>

    			<div class="col-sm-12">

					<ol>
					  <li>Conecta a API publica jsonplaceholder.typicode.com/users</li>
					  <li>Obtiene lista de usuarios (users) en un buffer</li>
					  <li>Recupera el objeto codificado JSON en aData</li>
					  <li>Devuelve elemento 1 de la lista dentro de un <em>textarea</em></li>
					</ol>

               <?prg 

						local hCurl, cBuffer := ""
						local aData := {}
						local cUrl 	:= "http://jsonplaceholder.typicode.com/users"

						curl_global_init()	

						if ! empty( hCurl := curl_easy_init() )

							curl_easy_setopt( hCurl, HB_CURLOPT_URL, cUrl )
							curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )

							if curl_easy_perform(hCurl) == 0
								cBuffer := curl_easy_dl_buff_get( hCurl )

								if !empty(cBuffer)
									hb_jsonDecode( cBuffer, @aData )
								endif
							endif
						endif

						curl_global_cleanup()
						return '<textarea rows="30" cols="50">'+hb_jsonEncode( aData[1], .T. )+'</textarea>'
               ?>

				<div>
			</div>
		</div>
		</body>
		</html>
	ENDTEXT

return NIL

//----------------------------------------------------------------------------------------//
