#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\contrib\hbcurl\hbcurl.ch"
#else
   #include "/usr/include/harbour/hbcurl.ch"
#endif

function Main()

  ? "Hello world"

  ? callPHP( "www.fivetechsoft.com/getip.php" ) 

return nil

function callPHP( cUrl )

   local uValue

   curl_global_init()

   if ! empty( hCurl := curl_easy_init() )
        curl_easy_setopt( hCurl, HB_CURLOPT_URL, cUrl )
        curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )

        if curl_easy_perform( hCurl ) == 0
           uValue = curl_easy_dl_buff_get( hCurl )
        endif
   endif

   curl_global_cleanup()

return uValue
