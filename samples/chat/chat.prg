function Main()

   local n
   
   Start()
   
   ?? "<div class='browse'>"
   for n = 1 to 50
      DispRecord()
   next   
   if AP_Method() == "POST"
      DispRecord( AP_PostPairs()[ "msg" ] )
   endif   
   ?? "</div>"
   
   ?? '<form action="chat.prg" method="post">'
   ?? '<br><br><input type="text" id="msg" name="msg" size="90">'
   ?? '<button type="submit">Send</button>'
   ?? '</form>'
   
   EndPage()
   
return nil   

function Start()

   ?? "<html>"
   ?? "<head>"
   ?? "</head>"
   ?? "<style>"
   ?? ".browse {"
   ?? "  overflow-y: scroll;"
   ?? "  height: 600px;"
   ?? "}"
   ?? ".record {"
   ?? "   width:700px;"
   ?? "}"
   ?? ".record:hover {"
   ?? "   background-color: rgb(248,248,248);"
   ?? "}"
   ?? "</style>"
   ?? "<body style='background-color:purple;'>"

return nil

function DispRecord( cMsg )

   ?? "<div class='record'>"
   ?? "<img src='https://ca.slack-edge.com/TJH5YU202-UNAHBRTFA-g3d2a3f4c28c-48' width=40 height=40>"
   ?? "<a><b>mod_harbour</b></a>"
   ?? "<a>"+ If( Empty( cMsg ), "18:30", Left( Time(), 5 ) ) + "</a><br>"
   ?? "<a style='padding-left:50px;'>" + If( Empty( cMsg ), "Hello my friends", cMsg )+ "</a>"
   ?? "</div>"

return nil

function EndPage()

   ?? "</body>"
   ?? "</html>"
   
return nil   
