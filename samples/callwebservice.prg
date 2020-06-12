#ifdef __PLATFORM__WINDOWS
   #include "c:\harbour\contrib\hbcurl\hbcurl.ch"
#else
   #include "/usr/include/harbour/hbcurl.ch"
#endif

function Main()

   ? UseWebService()
   
return nil  

function UseWebService()

   local uValue

   curl_global_init()

   if ! empty( hCurl := curl_easy_init() )
        curl_easy_setopt( hCurl, HB_CURLOPT_POST, 1 )
        curl_easy_setopt( hCurl, HB_CURLOPT_URL, "http://www.modharbour.org/modharbour_samples/webservice.prg" )
        curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )
        curl_easy_setopt( hCurl, HB_CURLOPT_POSTFIELDS, hb_jsonEncode( { "key1" => "value1", "key2" => "value2", "key3" => "value3" } ) )

        if curl_easy_perform( hCurl ) == 0
           uValue = curl_easy_dl_buff_get( hCurl )
        endif
   endif

   curl_global_cleanup()

return uValue
