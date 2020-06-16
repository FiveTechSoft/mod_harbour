/*
**  apache.prg -- Apache harbour module
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include "hbhrb.ch"

#xcommand ? [<explist,...>] => MH_Echo( '<br>' [,<explist>] )

#define CRLF hb_OsNewLine()

#define __HBEXTERN__HBHPDF__REQUEST
#include "../../harbour/contrib/hbhpdf/hbhpdf.hbx"
#define __HBEXTERN__XHB__REQUEST
#include "../../harbour/contrib/xhb/xhb.hbx"
#define __HBEXTERN__HBCT__REQUEST
#include "../../harbour/contrib/hbct/hbct.hbx"
#define __HBEXTERN__HBCURL__REQUEST  
#include "../../harbour/contrib/hbcurl/hbcurl.hbx"
#define __HBEXTERN__HBNETIO__REQUEST
#include "../../harbour/contrib/hbnetio/hbnetio.hbx"
#define __HBEXTERN__HBMZIP__REQUEST
#include "../../harbour/contrib/hbmzip/hbmzip.hbx"
#define __HBEXTERN__HBZIPARC__REQUEST
#include "../../harbour/contrib/hbziparc/hbziparc.hbx"
#define __HBEXTERN__HBSSL__REQUEST
#include "../../harbour/contrib/hbssl/hbssl.hbx"

#ifdef HB_WITH_ADS
   #define __HBEXTERN__RDDADS__REQUEST
   #include "../../harbour/contrib/rddads/rddads.hbx"
#endif

#ifdef __PLATFORM__WINDOWS
   #include "..\windows\modharbour.hbx"
#else
   #include "../linux/modharbour.hbx"   
#endif

//----------------------------------------------------------------//

function Main()

   local cFileName, pThread, nRetCode

   QQOut( "modharbour.exe (c) The Harbour Project 2020" )

   ErrorBlock( { | o | DoBreak( o ) } )
   AddPPRules()

   while ( nRetCode := FCGI_Accept() ) >= 0
      mh_Header( "Content-type: text/html" )
      if File( cFileName := mh_FileName() )
         hb_SetEnv( "PRGPATH",;
                    SubStr( cFileName, 1, RAt( "/", cFileName ) + RAt( "\", cFileName ) - 1 ) )
         if Lower( Right( cFileName, 4 ) ) == ".hrb"
            pThread = hb_threadStart( @ExecuteHrb(), hb_HrbLoad( 1, cFileName ), MH_Query() )
         else
            pThread = hb_threadStart( @Execute(), MemoRead( cFileName ), MH_Query() )
         endif
         if hb_threadWait( pThread, Max( Val( MH_GetEnv( "MHTIMEOUT" ) ), 15 ) ) != 1
            hb_threadQuitRequest( pThread )
            SetExitStatus( 408 ) // request timeout
         endif    
      else
         SetExitStatus( 404 ) // not found
      endif
   end

   QOut( "This is the server to be placed at c:\Apache24\bin" )

   if nRetCode < 0 
      if ! Empty( hb_pValue( 1 ) ) .and. File( hb_pValue( 1 ) )
         Execute( MemoRead( hb_pValue( 1 ) ) )
      else
         QOut( "syntax: modharbour.exe name.prg (displays the output)" )
      endif      
   endif   

return nil

//----------------------------------------------------------------//

function GetErrorInfo( oError, cCode )

   local n, cInfo := "Error: " + oError:description + "<br>"
   local aLines, nLine

   if ! Empty( oError:operation )
      cInfo += "operation: " + oError:operation + "<br>"
   endif   

   if ! Empty( oError:filename )
      cInfo += "filename: " + oError:filename + "<br>"
   endif   
   
   if ValType( oError:Args ) == "A"
      for n = 1 to Len( oError:Args )
          cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + ValToChar( oError:Args[ n ] ) + ;
                   If( ValType( oError:Args[ n ] ) == "A", " Len: " + ;
                   AllTrim( Str( Len( oError:Args[ n ] ) ) ), "" ) + "<br>"
      next
   endif	
	
   n = 2
   while ! Empty( ProcName( n ) )  
      cInfo += "called from: " + If( ! Empty( ProcFile( n ) ), ProcFile( n ) + ", ", "" ) + ;
               ProcName( n ) + ", line: " + ;
               AllTrim( Str( ProcLine( n ) ) ) + "<br>"
      n++
   end

   if ! Empty( cCode )
      aLines = hb_ATokens( cCode, Chr( 10 ) )
      cInfo += "<br>Source:<br>" + CRLF
      n = 1
      while( nLine := ProcLine( ++n ) ) == 0
      end   
      for n = Max( nLine - 2, 1 ) to Min( nLine + 2, Len( aLines ) )
         cInfo += StrZero( n, 4 ) + If( n == nLine, " =>", ": " ) + ;
                  hb_HtmlEncode( aLines[ n ] ) + "<br>" + CRLF
      next
   endif      

return cInfo

//----------------------------------------------------------------//

function ObjToChar( o )

   local hObj := {=>}, aDatas := __objGetMsgList( o, .T. )
   local hPairs := {=>}, aParents := __ClsGetAncestors( o:ClassH )

   AEval( aParents, { | h, n | aParents[ n ] := __ClassName( h ) } ) 

   hObj[ "CLASS" ] = o:ClassName()
   hObj[ "FROM" ]  = aParents 

   AEval( aDatas, { | cData | hPairs[ cData ] := __ObjSendMsg( o, cData ) } )
   hObj[ "DATAs" ]   = hPairs
   hObj[ "METHODs" ] = __objGetMsgList( o, .F. )

return ValToChar( hObj )

//----------------------------------------------------------------//

function ValToChar( u )

   local cType := ValType( u )
   local cResult

   do case
      case cType == "C" .or. cType == "M"
           cResult = u

      case cType == "D"
           cResult = DToC( u )

      case cType == "L"
           cResult = If( u, ".T.", ".F." )

      case cType == "N"
           cResult = AllTrim( Str( u ) )

      case cType == "A"
           cResult = hb_ValToExp( u )

      case cType == "O"
           cResult = ObjToChar( u )

      case cType == "P"
           cResult = "(P)" 

      case cType == "S"
           cResult = "(Symbol)" 
 
      case cType == "H"
           cResult = StrTran( StrTran( hb_JsonEncode( u, .T. ), CRLF, "<br>" ), " ", "&nbsp;" )
           if Left( cResult, 2 ) == "{}"
              cResult = StrTran( cResult, "{}", "{=>}" )
           endif   

      case cType == "U"
           cResult = "nil"

      otherwise
           cResult = "type not supported yet in function ValToChar()"
   endcase

return cResult   

//----------------------------------------------------------------//

function hb_HtmlEncode( cString )
   
   local cChar, cResult := "" 

   for each cChar in cString
      do case
      case cChar == "<"
            cChar = "&lt;"

      case cChar == '>'
            cChar = "&gt;"     
            
      case cChar == "&"
            cChar = "&amp;"     

      case cChar == '"'
            cChar = "&quot;"    
            
      case cChar == " "
            cChar = "&nbsp;"               
      endcase
      cResult += cChar 
   next
    
return cResult   

//----------------------------------------------------------------//