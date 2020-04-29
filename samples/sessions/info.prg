//-------------------------------------------------------------------------------------//

/*
   info.prg - Example - Sessions Engine for mod_harbour
   (c) 2020 Lorenzo De Linares Álvarez - lorenzo.linares@icloud.com
   Released under MIT Licence. Please use it giving credit to the author of the code.
*/

//-------------------------------------------------------------------------------------//

function Main()

    local cHtml := ""
    if Empty( GetSession() )
        ? "<script>location.href='index.prg';</script>"
    else
        cHtml += "<html>" + CRLF
        cHtml += "<head>" + CRLF
        cHtml += "<title>Sessions Example</title>" + CRLF
        cHtml += "</head>" + CRLF
        cHtml += "<body>" + CRLF
        cHtml += "<h2>Hello " + GetSessionByKey( "name" ) + "!</h2>" + CRLF
        cHtml += "Your user is: " + GetSessionByKey( "user" ) + "<br>" + CRLF
        cHtml += "<a href='logout.prg'>Logout</a>" + CRLF
        cHtml += "</body>" + CRLF
        cHtml += "</html>"
        ?? cHtml
    endif

return nil

//-------------------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/sessions.prg" ) %}