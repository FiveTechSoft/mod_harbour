procedure main()

    TEMPLATE
        <html>
            <head>
                <meta charset="utf-8">
                <title>POST example</title>
            </head>
            <body>
                <form action="mypost.prg?lang=en" method="POST">
                    User name:
                    <br>
                    <input type="text" name="username">
                    <br>
                    Password:
                    <br>
                    <input type="password" name="passw">
                    <br><br>
                    <input type="submit" value="Send data">
                </form>
            </body>
        </html>
   ENDTEXT

return 
