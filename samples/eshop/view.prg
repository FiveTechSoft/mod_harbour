function View( cView )

   local cData := MemoRead( hb_GetEnv( "PRGPATH" ) + "/views/" + cView + ".view" )

   while ReplaceBlocks( @cData, "{{", "}}" )
   end

return cData