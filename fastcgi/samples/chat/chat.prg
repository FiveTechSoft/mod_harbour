function Main()

   if ! File( hb_GetEnv( "PRGPATH" ) + "/chat.dbf" )
      DbCreate( hb_GetEnv( "PRGPATH" ) + "/chat.dbf",;
                { { "TIME",        "C",  8, 0 },;
                  { "USERID",      "C", 15, 0 },;
                  { "MSG",         "M", 10, 0 } } )
   endif   
   
   USE ( hb_GetEnv( "PRGPATH" ) + "/chat" ) SHARED NEW   
   
   if Empty( mh_Query() )
      BeginPage()

      ?? "<div class='browse' id='browse'>"
   endif   
   
   GetItems()

   if Empty( mh_Query() )
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

   local hPostPairs := mh_PostPairs()

   while ! EOF()
      DispRecord()
      SKIP
   end   
   if mh_Method() == "POST" .and. ! Empty( hPostPairs[ "msg" ] ) .and. ;
      ( ! "<SCRIPT" $ Upper( hb_UrlDecode( hPostPairs[ "msg" ] ) ) .and. ;
        ! "<STYLE" $ Upper( hb_UrlDecode( hPostPairs[ "msg" ] ) ) )
      APPEND BLANK
      if RLock()
         Field->Time   := Left( Time(), 5 )
         Field->UserId := mh_UserIP()
         Field->Msg    := hb_UrlDecode( hPostPairs[ "msg" ] ) 
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
         <link href="https://fonts.googleapis.com/css?family=Lato:300,400&display=swap" rel="stylesheet">
      </head>
      <style>
         .browse {
            overflow-y: scroll;
            width: 700px;
            height: 600px;
            background-color:white;
            font-family: 'Lato', sans-serif;
            font-weight: 400;
          }
          .record {
            width:700px;
          }
          .record:hover {
            background-color: rgb(246, 246, 246);
          }
          .row {
	         display: flex;
			   padding-left: 4px;
			   padding-bottom: 4px;
			   padding-top: 4px;
          }
          .profile-img {
	         flex: 7%;
          }
          .message {
	         flex: 93%;
          }
          .img-profile {
			   border-radius: 5px;
          }
          .username {
            font-size: 15px;
            font-weight: bold;
          }
          .timetop {
            padding-left: 10px;
            color: #747474;
            font-size: 12px;
          }
		    .timeleft {
			   padding-left: 7px;
			   padding-top: 3px;
			   font-size: 12px;
			   color: rgba( 255, 255, 255, 0 );
        }
        .content {
            font-size: 15px;
        }
		  .record:hover .timeleft {
			  color: #747474;
		  }
      </style>
      <script>
         function scrollToBottom( id )
         {
            var div = document.getElementById( id );
            div.scrollTop = div.scrollHeight - div.clientHeight;
         }
         
         var tmpdata;

         function LoadItems() 
         {
            fetch( "chat.prg?items" ).then( res => {
               if( res.ok ) {
                     return res.text();
                  } else {
                     throw new Error( res.status + " " + res.statusText );
                  }
               } ).then( data => {
                  console.log( data );
                  if( tmpdata != data )
                  {
                     document.getElementById( 'browse' ).innerHTML = data; 
                     scrollToBottom( "browse" );
                     tmpdata = data;
                  } } );
         }
     </script>    
     <body style='background-color:purple;'>
   ENDTEXT

return nil

//----------------------------------------------------------------------------//

function DispRecord()

   static cLastUserId := ""
   
   if cLastUserId != Field->UserId
      ?? "<div class='record'>"
      ?? "<div class='row'>"
      ?? "<div class ='profile-img'>"
      ?? "<img class='img-profile' src='img/profile-default.png' width=40 height=40>"
      ?? "</div>"
      ?? "<div class='message'>"
      ?? "<a class='username'>" + AllTrim( Field->UserId ) + "</a>"
      ?? "<a class='timetop'>" + AllTrim( Field->Time ) + "</a><br>"
      ?? "<a class='content'>" + AllTrim( Field->Msg ) + "</a>"
      ?? "</div>"
      ?? "</div>"
      ?? "</div>"
      cLastUserId = Field->UserId
   else
      ?? "<div class='record'>"
      ?? "<div class='row'>"
      ?? "<div class ='profile-img'>"
      ?? "<div class='timeleft'>" + AllTrim( Field->Time ) + "</div>"
      ?? "</div>"
      ?? "<div class='message'>"
      ?? "<a class='content'>" + AllTrim( Field->Msg ) + "</a>"
      ?? "</div>"
      ?? "</div>"
      ?? "</div>"
   endif

return nil

//----------------------------------------------------------------------------//

function EndPage()

   ?? "</body>"
   ?? "</html>"
   
return nil   

//----------------------------------------------------------------------------//
