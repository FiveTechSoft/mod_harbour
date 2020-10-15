/*
**  apache.prg -- Apache harbour module
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include "hbhrb.ch"

#xcommand ? [<explist,...>] => AP_RPuts( '<br>' [,<explist>] )

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
#define __HBEXTERN__HBZEBRA__REQUEST
#include "../../harbour/contrib/hbzebra/hbzebra.hbx"

#ifdef __PLATFORM__WINDOWS
   #define __HBEXTERN__HBWIN__REQUEST
   #include "../../harbour/contrib/hbwin/hbwin.hbx"
#endif  

#ifdef HB_WITH_ADS
   #define __HBEXTERN__RDDADS__REQUEST
   #include "../../harbour/contrib/rddads/rddads.hbx"
#endif

extern MWRITE, MREAD, SHOWCONSOLE, AP_ARGS, AP_BODY, AP_FILENAME
extern AP_GETENV, AP_HEADERSINCOUNT, AP_HEADERSINKEY, AP_HEADERSINVAL, AP_HEADERSIN
extern AP_METHOD, AP_USERIP, AP_HEADERSOUTCOUNT, AP_HEADERSOUTKEY, AP_HEADERSOUTVAL
extern AP_HEADERSOUTSET, AP_HEADERSOUT, AP_RPUTS, AP_RWRITE, AP_SETCONTENTTYPE
extern PTRTOSTR, PTRTOUI, HB_URLDECODE, MODBUILDDATE

//----------------------------------------------------------------//

function Main()

   local cFileName, pThread

   ErrorBlock( { | o | DoBreak( o ) } )

   cFileName = AP_FileName()
   AddPPRules()

   if File( cFileName )
      hb_SetEnv( "PRGPATH",;
                 SubStr( cFileName, 1, RAt( "/", cFileName ) + RAt( "\", cFileName ) - 1 ) )
      if Lower( Right( cFileName, 4 ) ) == ".hrb"
         pThread = hb_threadStart( @ExecuteHrb(), hb_HrbLoad( 1, cFileName ), AP_Args() )
      else
         pThread = hb_threadStart( @Execute(), MemoRead( cFileName ), AP_Args() )
      endif
      if hb_threadWait( pThread, Max( Val( AP_GetEnv( "MHTIMEOUT" ) ), 15 ) ) != 1
         hb_threadQuitRequest( pThread )
	      ErrorLevel( 408 ) // request timeout
      endif    
      InKey( 0.1 )
   else
      ErrorLevel( 404 ) // not found
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

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>

static void * pRequestRec;

HB_EXPORT_ATTR int hb_apache( void * _pRequestRec )
{
   pRequestRec = _pRequestRec;
 
   hb_vmInit( HB_TRUE );
   return hb_vmQuit();
}   

void * GetRequestRec( void )
{
   return pRequestRec;
}

#pragma ENDDUMP

//----------------------------------------------------------------//
