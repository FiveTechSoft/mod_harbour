/*
**  pairs.prg -- mod_harbour pairs management module
**
** Developed by Antonio Linares & Carles Aubia
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

//----------------------------------------------------------------//

function MH_PostPairs( lUrlDecode )

   local aPairs := hb_ATokens( MH_Body(), "&" )
   local cPair, uPair, hPairs := {=>}
   local nTable, aTable, cKey, cTag	

   hb_default( @lUrlDecode, .T. )
   cTag = If( lUrlDecode, '[]', '%5B%5D' )
   
   for each cPair in aPairs
      if lUrlDecode
         cPair = hb_urlDecode( cPair )
      endif				

      if ( uPair := At( "=", cPair ) ) > 0	  
         cKey = Left( cPair, uPair - 1 )	
         if ( nTable := At( cTag, cKey ) ) > 0 		
            cKey = Left( cKey, nTable - 1 )			
            aTable = HB_HGetDef( hPairs, cKey, {} ) 				
            AAdd( aTable, SubStr( cPair, uPair + 1 ) )				
            hPairs[ cKey ] = aTable
         else						
            hb_HSet( hPairs, cKey, SubStr( cPair, uPair + 1 ) )
         endif
      endif
   next
    
return hPairs

//----------------------------------------------------------------//

function MH_GetPairs( lUrlDecode )	

   local cArgs 	:= MH_query()
   local hPairs := {=>}
   local cPair, uPair, nPos, cKey
	
   hb_default( @lUrlDecode, .T. )
   
   for each cPair in hb_ATokens( cArgs, "&" )
      if lUrlDecode
	 cPair = hb_urldecode( cPair )
      endif		
      if ( uPair := At( "=", cPair ) ) > 0
         cKey := Left( cPair, uPair - 1 )			
	 if ( nPos := HB_HPos( hPairs, cKey ) ) == 0
	    hb_HSet( hPairs, cKey, SubStr( cPair, uPair + 1 ) )
	 else
	    uValue = hPairs[ cKey ] 				
            hPairs[ cKey ] = {}
	    AAdd( hPairs[ cKey ], uValue )
            AAdd( hPairs[ cKey ], SubStr( cPair, uPair + 1 ) )
         endif				
      else
	 HB_HSet( hPairs, Lower( cPart ), '' )
      endif
   next

return hPairs

//----------------------------------------------------------------//
