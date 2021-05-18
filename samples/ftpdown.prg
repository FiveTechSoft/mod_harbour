#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\contrib\hbcurl\hbcurl.ch"
#else
   #include "/usr/include/harbour/hbcurl.ch"
#endif

function main()

	local hCurl
	local cUrl 	:= 'https://raw.githubusercontent.com/FiveTechSoft/FWH_tools/master/README.md'	
	local cFile 	:= hb_GetEnv( 'PRGPATH' ) + '/myreadme.md'
	
	if ! empty( hCurl := curl_easy_init() )  
  
		curl_easy_setopt( hCurl, HB_CURLOPT_DOWNLOAD )
		curl_easy_setopt( hCurl, HB_CURLOPT_URL, cURL )		
		
		curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYPEER, .f. )
		curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYHOST, .f. )
		curl_easy_setopt( hCurl, HB_CURLOPT_FOLLOWLOCATION )        
		curl_easy_setopt( hCurl, HB_CURLOPT_FILETIME, 1)
		curl_easy_setopt( hCurl, HB_CURLOPT_DL_FILE_SETUP, cFile)
		curl_easy_setopt( hCurl, HB_CURLOPT_NOPROGRESS, .f. )
		curl_easy_setopt( hCurl, HB_CURLOPT_VERBOSE, .f. )	 		
		curl_easy_setopt( hCurl, HB_CURLOPT_FAILONERROR , .t. )	 //	Change cUrl Dummy		
		
		nRet := curl_easy_perform( hCurl ) 

		
		if nRet == HB_CURLE_OK 	//	HB_CURLE_OK == 0		   
		   ? 'Total Time:', curl_easy_getinfo( hCurl, HB_CURLINFO_TOTAL_TIME )
		   ? 'Download to -> ', cFile
		else
		   ? 'Error ->', curl_easy_strerror( nRet )
		endif	

		curl_global_cleanup()	
		
	endif	
	
return nil
