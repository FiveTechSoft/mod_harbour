#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\contrib\hbcurl\hbcurl.ch"
#else
   #include "/usr/include/harbour/hbcurl.ch"
#endif

function Main()

  curl_global_init()
   
  ? FtpUploadFile( "ftp://fivetechsoft.com/test.prg", hb_GetEnv( "PRGPATH" ) + "/test.prg" ) 

   curl_global_cleanup()

return nil

function FtpUploadFile( cUrlFileName, cFileName )

   local hCurl, uValue, nResult

   if ! empty( hCurl := curl_easy_init() )
      curl_easy_setopt( hCurl, HB_CURLOPT_URL, cUrlFileName )
      curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )
      curl_easy_setopt( hCurl, HB_CURLOPT_UPLOAD )
      curl_easy_setopt( hCurl, HB_CURLOPT_UL_FILE_SETUP, cFileName )
      curl_easy_setopt( hCurl, HB_CURLOPT_INFILESIZE, hb_vfSize( cFileName ) )
      curl_easy_setopt( hCurl, HB_CURLOPT_USERPWD, "username:password" )
      curl_easy_setopt( hCurl, HB_CURLOPT_FAILONERROR, .T. )
      curl_easy_setopt( hCurl, HB_CURLOPT_FILETIME, .T. )
      curl_easy_setopt( hCurl, HB_CURLOPT_NOPROGRESS, 0 )
      curl_easy_setopt( hCurl, HB_CURLOPT_VERBOSE, .F. )

      if ( nResult := curl_easy_perform( hCurl ) ) == 0
         curl_easy_dl_buff_get( hCurl )
      else
         ? "error code:" + Str( nResult )   
      endif
   endif

return nResult == HB_CURLE_OK
