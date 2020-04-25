// Calling a function inside another PRG

function Main()

   ? Do( "https://www.modharbour.org/modharbour_samples/testdo.prg", "Test", 123, 456 )
   
return nil   

function Do( cUrlPRG, cFuncName, ... )

   local uValue, aParams := hb_AParams(), hParams
   
   hb_ADel( hParams, 1, .T. )
   hb_ADel( hParams, 1, .T. )

   hParams = { "function" => cFuncName,; 
               "params"   => hParams }

   curl_global_init()

   if ! empty( hCurl := curl_easy_init() )
        curl_easy_setopt( hCurl, HB_CURLOPT_URL, cUrlPRG )
        curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )
        curl_easy_setopt( hCurl, HB_CURLOPT_POSTFIELDS, hb_jsonEncode( hParams ) )
        curl_easy_setopt( hCurl, HB_CURLOPT_POST, 1 )

        if curl_easy_perform( hCurl ) == 0
           uValue = curl_easy_dl_buff_get( hCurl )
        endif
   endif

   curl_global_cleanup()

return uValue
