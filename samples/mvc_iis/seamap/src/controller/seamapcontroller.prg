//----------------------------------------------------------------------------//

CLASS SeamapController

    METHOD New( oController )

    METHOD Default( oController )
        
    METHOD Add( oController )    
    METHOD Del( oController )    
    METHOD Edit( oController )    
    METHOD Save( oController )    

ENDCLASS    

//----------------------------------------------------------------------------//

METHOD New( oController ) CLASS SeamapController

    local cAction := Lower( oController:oRequest:Post( 'action' ) )

    do case
       case cAction == "add"
          ::Add( oController )
		  
	   case cAction == 'del'
		  ::Del( oController )

	   case cAction == 'edit'
		  ::Edit( oController )	

	   case cAction == 'save'
		  ::Save( oController )		  

       otherwise
          ::Default( oController ) 
		  
    endcase

return Self    

//----------------------------------------------------------------------------//

METHOD Default( oController ) CLASS SeamapController

   local oModelSeamap 	:= SeamapModel():New()
   local hData 		:= oModelSeamap:Browse()

   oController:View( "seamap.view", hData )

return nil    

//----------------------------------------------------------------------------//

METHOD Add( oController ) CLASS SeamapController

   local oModelSeamap := SeamapModel():New()

   oModelSeamap:Add()
	
   ::Default( oController )

return nil    

//----------------------------------------------------------------------------//

METHOD Del( oController ) CLASS SeamapController

   local oModelSeamap := SeamapModel():New()
   local nRecno       := oController:oRequest:Post( 'recno', 0, 'N' )
	
   oModelSeamap:Delete( nRecno )
	
   ::Default( oController )	

return nil    

//----------------------------------------------------------------------------//

METHOD Edit( oController ) CLASS SeamapController

   local oModelSeamap := SeamapModel():New()
   local nRecno       := oController:oRequest:Post( 'recno', 0, 'N' )
   local hData        := oModelSeamap:Edit( nRecno )	
	
   oController:View( "seamap_edit.view", hData )	

return nil    

//----------------------------------------------------------------------------//

METHOD Save( oController ) CLASS SeamapController

   local oModelSeamap := SeamapModel():New()
   local nRecno       := oController:oRequest:Post( 'recno', 0, 'N' )
   local hData 	      := {=>}
	
   hData[ 'LINKDEST' ] := oController:oRequest:Post( 'LINKDEST' )
   hData[ 'LINKNAME' ] := oController:oRequest:Post( 'LINKNAME' )
   hData[ 'LONGTEXT' ] := oController:oRequest:Post( 'LONGTEXT' )

   oModelSeamap:Save( nRecno, hData ) 	
   ::Default( oController )

return nil    

//----------------------------------------------------------------------------//

{% MemoRead( hb_GetEnv( "PRGPATH" ) + "/src/model/seamapmodel.prg" ) %}