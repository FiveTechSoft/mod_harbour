//----------------------------------------------------------------------------//

function Main()

   ?? View( "default" )    

return nil

//----------------------------------------------------------------------------//

function GetContent()

return Form( 150, 350, 600, 500 )    

//----------------------------------------------------------------------------//

function Form( nTop, nLeft, nWidth, nHeight )

    local hForm := {=>}

    hForm[ "top" ] = nTop
    hForm[ "left" ] = nLeft
    hForm[ "width" ] = nWidth
    hForm[ "height" ] = nHeight

return "<script>Form(" + hb_jsonEncode( hForm ) + ")</script>"

//----------------------------------------------------------------------------//

function View( cName )

    local cData
 
    if File( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
       cData = MemoRead( hb_GetEnv( "PRGPATH" ) + "/views/" + cName + ".view" )
       while ReplaceBlocks( @cData, "{{", "}}" )
       end
    else
       cData = "<h2>" + cName + " not found!</h2>" 
    endif    
 
 return cData
 
 //----------------------------------------------------------------------------//