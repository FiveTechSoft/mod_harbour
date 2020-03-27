function Main()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/chat.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/chat.dbf",;
                { { "TIME",        "C",  8, 0 },;
                  { "USERID",      "C", 15, 0 },;
                  { "MSG",         "M", 10, 0 } } )
   endif   
   
   USE ( hb_GetEnv( "PRGPATH" ) + "/chat" ) SHARED NEW   
   
   if Empty( AP_Args() )
      BeginPage()

      ?? "<div class='browse' id='browse'>"
   endif   
   
   GetItems()

   if Empty( AP_Args() )
      ?? "</div>"
   
      TEMPLATE
         <form action="chat.prg" method="post">
            <br><br><input type="text" id="msg" name="msg" size="88" autofocus>
            <button type="submit">Send</button>
         </form>
         <script>
            scrollToBottom( "browse" );
            setInterval( LoadItems, 3000 );
         </script>
      ENDTEXT

      EndPage()
   endif   
   
   USE
   
return nil   

//----------------------------------------------------------------------------//

function GetItems()

   while ! EOF()
      DispRecord()
      SKIP
   end   
   if AP_Method() == "POST"
      APPEND BLANK
      if RLock()
         Field->Time   := Left( Time(), 5 )
         Field->UserId := "Test"
         Field->Msg    := hb_UrlDecode( AP_PostPairs()[ "msg" ] ) 
         DbUnLock()
      endif         
      DispRecord()
   endif   
   
return nil   

//----------------------------------------------------------------------------//

function BeginPage()

   TEMPLATE
      <html>
      <head>
         <meta charset="UTF-8">
      </head>
      <style>
         .browse {
            overflow-y: scroll;
            width: 700px;
            height: 600px;
            background-color:white;
            font-family: sans-serif;
          }
          .record {
             width:700px;
          }
          .record:hover {
             background-color: rgb(248,248,248);
          }
          .row {
	         display: flex;
			 padding-left: 2px;
			 padding-bottom: 3px;
			 padding-top: 3px;
          }
          .profile-img {
	          flex: 7%;
          }
          .message {
	          flex: 93%;
	          padding-top: 5px;
          }
          .time {
	          font-size: smaller;
	          color: gray;
          }
      </style>
      <script>
         function scrollToBottom( id )
         {
            var div = document.getElementById( id );
            div.scrollTop = div.scrollHeight - div.clientHeight;
         }
         
         function LoadItems() 
         {
            scrollToBottom( "browse" );
            fetch( "chat.prg?items" ).then( res => {
               if( res.ok ) {
                     return res.text();
                  } else {
                     throw new Error( res.status + " " + res.statusText );
                  }
               } ).then( data => {
                  console.log( data );
                  document.getElementById( 'browse' ).innerHTML = data; } );
         }
     </script>    
     <body style='background-color:purple;'>
   ENDTEXT

return nil

//----------------------------------------------------------------------------//

function DispRecord()

   ?? "<div class='record'>"
   ?? "<div class='row'>"
   ?? "<div class ='profile-img'>"
   ?? "<img src='img/profile-default.png' width=40 height=40>"
   ?? "</div>"
   ?? "<div class='message'>"
   ?? "<a><b>" + AllTrim( Field->UserId ) + "</b></a>"
   ?? "<a class='time'>"+ Field->Time + "</a><br>"
   ?? "<a style='padding-left:50px;'>" + AllTrim( Field->Msg ) + "</a>"
   ?? "</div>"
   ?? "</div>"
   ?? "</div>"

return nil

//----------------------------------------------------------------------------//

function EndPage()

   ?? "</body>"
   ?? "</html>"
   
return nil   

//----------------------------------------------------------------------------//
