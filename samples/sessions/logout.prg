//-------------------------------------------------------------------------------------//

/*
   logout.prg - Example - Sessions Engine for mod_harbour
   (c) 2020 Lorenzo De Linares Álvarez - lorenzo.linares@icloud.com
   Released under MIT Licence. Please use it giving credit to the author of the code.
*/

//-------------------------------------------------------------------------------------//

function Main()

    SessionDestroy()
    ? "<script>location.href='index.prg';</script>"

return nil

//-------------------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/sessions.prg" ) %}