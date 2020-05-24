//----------------------------------------------------------------//

function PathUrl()

   local cPath := AP_GetEnv( 'SCRIPT_NAME' )   
   local n     := RAt( '/', cPath )
        
return Substr( cPath, 1, n - 1 )

//----------------------------------------------------------------//

function PathBase( cDirFile )

   local cPath := hb_GetEnv( "PRGPATH" ) 
    
   hb_default( @cDirFile, '' )
    
   cPath += cDirFile
    
   if "Linux" $ OS()    
      cPath = StrTran( cPath, '\', '/' )     
   endif
   
return cPath

//----------------------------------------------------------------//

function Include( cFile )

   local cPath := AP_GetEnv( "DOCUMENT_ROOT" ) 

   hb_default( @cFile, '' )
   cFile = cPath + cFile   
   
   if "Linux" $ OS()
      cFile = StrTran( cFile, '\', '/' )     
   endif   
    
   if File( cFile )
      return MemoRead( cFile )
   endif
   
return ""

//----------------------------------------------------------------//