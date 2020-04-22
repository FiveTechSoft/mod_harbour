function Main()

   local cSecWebSocketAccept
   local cSecWebSocketKey := AP_HeadersIn()[ "Sec-WebSocket-Key" ]

   AP_HeadersOutSet( "Upgrade", "websocket" )
   AP_HeadersOutSet( "Connection", "Upgrade" )

   AP_HeadersOutSet( "Sec-WebSocket-Accept",;
                     cSecWebSocketAccept := hb_Base64Encode( hb_SHA1( cSecWebSocketKey + ;
                     "258EAFA5-E914-47DA-95CA-C5AB0DC85B11", .T. ) ) )

   // MemoWrit( "c:\temp\headersin.txt", ValToChar( Ap_HeadersIn() ) + CRLF + ;
   // cSecWebSocketKey + CRLF + cSecWebSocketAccept )

   ErrorLevel( 101 )  // Protocol change
   
return nil   
