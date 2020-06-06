/*
**  pairs.prg -- Apache pairs management module
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

//----------------------------------------------------------------//

function AP_PostPairs( lUrlDecode )

   local aPairs := hb_ATokens( AP_Body(), "&" )
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

function AP_GetPairs()

   local aPairs := hb_ATokens( AP_Args(), "&" )
   local cPair, aPair, hPairs := {=>} 

   for each cPair in aPairs
      aPair = hb_ATokens( cPair, "=" )
      if Len( aPair ) == 2 
         hPairs[ hb_UrlDecode( aPair[ 1 ] ) ] = hb_UrlDecode( aPair[ 2 ] )
      else
         hPairs[ hb_UrlDecode( aPair[ 1 ] ) ] = ""
      endif   
   next
   
return hPairs

//----------------------------------------------------------------//
