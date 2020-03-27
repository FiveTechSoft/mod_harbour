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
         <form>
			<div class="row">
				<div class="col-11 pr-1">
					<input type="text" class="form-control">
				</div>
				<div class="col pl-1">
					<button class="btn btn-primary w-100">Send</button>
				</div>
			</div>
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

   local hPostPairs := AP_PostPairs()

   while ! EOF()
      DispRecord()
      SKIP
   end   
   if AP_Method() == "POST" .and. ! Empty( hPostPairs[ "msg" ] ) .and. ; 
      ! "<SCRIPT" $ Upper( hPostPairs[ "msg" ] )
      APPEND BLANK
      if RLock()
         Field->Time   := Left( Time(), 5 )
         Field->UserId := AP_UserIP()
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
			<title>mod_harbour chat</title>
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
			<link href="https://fonts.googleapis.com/css?family=Lato:300,400&display=swap" rel="stylesheet">
			<style>
				.back {
					background-color: purple;
				}
				
				.browse {
					overflow-y: scroll;
					width: 100%;
					height: 92%;
					background-color: white;
					font-family: 'Lato', sans-serif;
					font-weight: 400;
					margin-bottom: 5px;
				}
				
				.record {
					margin: 0 auto;
					margin-top: 4px;
				}
				
				.record:hover {
					background-color: rgba(246, 246, 246);
				}
				
				.message-row {
					display: flex;
				}
				
				.message-row .image-column {
					flex: 2%;
					margin-right: 4px;
				}
				
				.message-row .text-column {
					flex: 98%;
					margin-left: 3px;
				}
				
				.profile-image {
					margin-top: 3px;
					margin-bottom: 4px;
					border-radius: 5px;
				}
				
				.time {
					color: #9c9c9c !important;
					font-size: 0.6em;
				}
				
				.time-column {
					color: rgba(255, 255, 255, 0) !important;
					font-size: 0.6em;
				}
				
				.record:hover .time-column{
					color: #9c9c9c !important;
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
		</head>
		<body class="back">
			<div class="container-fluid">
   ENDTEXT

return nil

//----------------------------------------------------------------------------//

function DispRecord()

   static cLastUserId := ""
   
   if cLastUserId != Field->UserId
      ?? "<div class='record'>"
      ?? "<div class='message-row'>"
      ?? "<div class ='image-column'>"
      ?? "<img class='profile-image' src='img/profile-default.png' width='40' height='40'>"
      ?? "</div>"
      ?? "<div class='text-column'>"
      ?? "<b>" + AllTrim( Field->UserId ) + "</b>"
      ?? "<a class='time'>"+ Field->Time + "</a><br>"
      ?? AllTrim( Field->Msg )
      ?? "</div>"
      ?? "</div>"
      ?? "</div>"
      cLastUserId = Field->UserId
   else
      ?? "<div class='record'>"
      ?? "<div class='message-row'>"
      ?? "<div class ='image-column' style='padding-top: 5px; padding-left: 5px;'>"
      ?? "<a class='time-column'>"+ Field->Time + "</a>"
      ?? "</div>"
      ?? "<div class='text-column'>"
      ?? AllTrim( Field->Msg )
      ?? "</div>"
      ?? "</div>"
      ?? "</div>"
   endif

return nil

//----------------------------------------------------------------------------//

function EndPage()

   ?? "</div>"
   ?? "</body>"
   ?? "</html>"
   
return nil   

//----------------------------------------------------------------------------//
