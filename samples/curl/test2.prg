/*
****************************************************************************
*   Aplicacion: Test basico para comprobar soporte CURL mod_harbour 	      *
*       Fuente: test2.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 12-08-2019                                                 *
****************************************************************************
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
			<title>Small photo gallery for mod_harbour</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>
		</head>
		<body>
		<div class="container">
  			<div class="row">
  			   <h1>Small photo gallery for mod_harbour</h1>

    			<div class="col-sm-12">

					<ol>
					  <li>Conecta a API publica jsonplaceholder.typicode.com/photos</li>
					  <li>Obtiene lista de fotos disponibles (5000) en un buffer</li>
					  <li>Recupera el objeto codificado JSON en aData</li>
					  <li>Muestra los 5 elementos</li>
					</ol>

               <?prg 

						local hCurl, cBuffer := ""
						local aData := {}
						local cUrl 	:= "http://jsonplaceholder.typicode.com/photos"
						local cHtml := ""
						local n

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

						/*
							Array de objetos recibido, estructura del objeto :
							{
						    "albumId": 1,
						    "id": 1,
						    "title": "accusamus beatae ad facilis cum similique qui sunt",
						    "url": "https://via.placeholder.com/600/92c952",
						    "thumbnailUrl": "https://via.placeholder.com/150/92c952"
						  	},
						*/

						cHtml += '<div class="card-group">'
						for n:=1 to 5
							cHtml += '<div class="card" style="width: 18rem;">'
							cHtml += '<img class="card-img-top" src="'+ aData[n]['thumbnailUrl'] +'" alt="Card image cap">'
							cHtml += '<div class="card-body">'
							cHtml += '<h5 class="card-title">Album '+ str( aData[n]['id'] ) +'</h5>'
							cHtml += '<a target="_blank_" href="'+ aData[n]['url'] +'" class="card-link">Big photo</a>'
							cHtml += '<div class="card-body">'
							cHtml += '<p class="card-text">'+ aData[n]['title'] +'</p>'
							cHtml += '</div></div></div>'
						next
						cHtml += '</div></div></div>'
						return cHtml
               ?>

				<div>
			</div>
		</div>
		</body>
		</html>
	ENDTEXT

return NIL

//----------------------------------------------------------------------------------------//
