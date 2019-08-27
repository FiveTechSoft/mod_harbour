/*
****************************************************************************
*   Aplicacion: Test para comprobar soporte https de CURL para mod_harbour *
*       Fuente: test3.prg 		                                             *
*        Autor: Joaquim Ferrer Godoy                                       *
*       Inicio: 27-08-2019                                                 *
****************************************************************************
*/
//#include "hbcurl.ch"
#define HB_CURLOPT_URL                        2
#define HB_CURLOPT_DL_BUFF_SETUP              1008
#define HB_CURLOPT_SSL_VERIFYPEER             64
#define HB_CURLOPT_SSL_VERIFYHOST             81
#define HB_CURLOPT_NOPROGRESS                 43  /* shut off the progress meter */
#define HB_CURLOPT_VERBOSE                    41  /* talk a lot */

function main()
	
	local hCurl, cBuffer := ""
	local cUrl 	:= "https://picsum.photos/v2/list?page=9&limit=5"

	curl_global_init()	

	if ! empty( hCurl := curl_easy_init() )

		curl_easy_setopt( hCurl, HB_CURLOPT_URL, cUrl )
      curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYPEER, .f. )
      curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYHOST, .f. )
      curl_easy_setopt( hCurl, HB_CURLOPT_NOPROGRESS, .f. )
      curl_easy_setopt( hCurl, HB_CURLOPT_VERBOSE, .t. )
		curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )

		if curl_easy_perform(hCurl) == 0
			cBuffer := curl_easy_dl_buff_get( hCurl )

			if !empty(cBuffer)
				?? View( cBuffer )
			endif
		endif
		
	endif

	curl_global_cleanup()

return NIL

//----------------------------------------------------------------------------------------//

static function View( cBuffer )

	local n
	local cHtml := ""
	local aData := {}

	hb_jsonDecode( cBuffer, @aData )
	
	cHtml += '<!DOCTYPE html>'
	cHtml += '<html lang="en">'
	cHtml += '<head>'
	cHtml += '	<meta charset="UTF-8">'
	cHtml += '	<title>Small photo gallery for mod_harbour</title>'
	cHtml += '	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>'
	cHtml += '	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"/>'
	cHtml += '</head>'
	cHtml += '<style>img {height:200px;}</style>'
	cHtml += '<body>'
	cHtml += '<div class="container">'
	cHtml += '	<h1>Small photo gallery for mod_harbour</h1>'
	cHtml += '	<p>Server query : <code>https://picsum.photos/v2/list?page=9&limit=5</code></p>'
	cHtml += '	<div class="row">'
	cHtml += '		<div class="card-group">'

	/* Estructura del registro
		[
			{
			id: "1006",
			author: "Vladimir Kudinov",
			width: 3000,
			height: 2000,
			url: "https://unsplash.com/photos/-wWRHIUklxM",
			download_url: "https://picsum.photos/id/1006/3000/2000"
			}
		]
	*/

	for n:=1 to 5
		cHtml += '<div class="card" style="width: 18rem;">'
		cHtml += '<img class="card-img-top" src="'+ aData[n]['download_url'] +'" alt="Card image cap">'
		cHtml += '<div class="card-body">'
		cHtml += '<h5 class="card-title">Photo '+ aData[n]['id'] +'</h5>'
		cHtml += '<a target="_blank_" href="'+ aData[n]['download_url'] +'" class="card-link">Big photo</a>'
		cHtml += '<div class="card-body">'
		cHtml += '<p class="card-text">'+ aData[n]['author'] +'</p>'
		cHtml += '</div></div></div>'
	next

	cHtml += '</div></div></div>'
	cHtml += '</body>'
	cHtml += '</html>'

return cHtml

//----------------------------------------------------------------------------------------//
