#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

//----------------------------------------------------------------//

function Main()

   ErrorSys( { | o | AP_RPuts( GetErrorInfo( o ) ) } )

   // AP_SetContentType( "text/html" )

   if File( AP_FileName() )
      Execute( MemoRead( AP_FileName() ), AP_Args() )
   else
      ? "File not found: " + AP_FileName()
   endif   

return nil

//----------------------------------------------------------------//

function Execute( cCode, ... )

   local oHrb, bOldError, uRet
   local cHBheaders := "~/harbour/include"

   oHrb = HB_CompileFromBuf( cCode, .T., "-n", "-I" + cHBheaders )
   if ! Empty( oHrb )
      BEGIN SEQUENCE
      bOldError = ErrorBlock( { | o | DoBreak( o ) } )
      uRet = hb_HrbDo( hb_HrbLoad( oHrb ), ... )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif

return uRet

//----------------------------------------------------------------//

function GetErrorInfo( oError )

   local cInfo := oError:operation, n
   local cCallStack := ""

   if ValType( oError:Args ) == "A"
      cInfo += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + ValToChar( oError:Args[ n ] ) + hb_OsNewLine()
      next
   endif
   
   n = 0
   while ! Empty( ProcName( n ) )
      cCallStack += "called from: " + ProcName( n ) + ", line: " + AllTrim( Str( ProcLine( n ) ) ) + "<br>" + CRLF
      n++
   end   

return "error: " + oError:Description + hb_OsNewLine() + cInfo + "<br><br>" + CRLF + ;
       cCallStack

//----------------------------------------------------------------//

static procedure DoBreak( oError )

   ? GetErrorInfo( oError )

   BREAK

//----------------------------------------------------------------//

function ValToChar( u )

   local cType := ValType( u )
   local cResult
   
   do case
      case cType == "C"
           cResult = u
           
      case cType == "D"
           cResult = DToC( u )
           
      case cType == "L"
           cResult = If( u, ".T.", ".F." )
           
      case cType == "N"
           cResult = AllTrim( Str( u ) )
           
      case cType == "A"
           cResult = "{ ... }"
           
      case cType == "P"
           cResult = "(P)" 
           
      case cType == "H"
           cResult = "{=>}"

      otherwise
           cResult = "type not supported yet in function ValToChar()"
   endcase
   
return cResult   

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>

static void * pRequestRec, * pAPRPuts, * pHeadersIn, * pHeadersOut;
static char * szFileName, * szArgs, * szMethod, * szUserIP;

int hb_apache( void * _pRequestRec, void * _pAPRPuts, char * cFileName, char * cArgs, const char * cMethod, char * cUserIP,
               void * _pHeadersIn, void * _pHeadersOut )
{
   pRequestRec = _pRequestRec;
   pAPRPuts    = _pAPRPuts; 
   szFileName  = cFileName;
   szArgs      = cArgs;
   szMethod    = cMethod;
   szUserIP    = cUserIP;
   pHeadersIn  = _pHeadersIn;
   pHeadersOut = _pHeadersOut;
 
   hb_vmInit( HB_TRUE );
   return hb_vmQuit();
}   

HB_FUNC( AP_RPUTS )
{
   int ( * ap_rputs )( const char * s, void * r ) = pAPRPuts;
   HB_SIZE nLen;
   HB_BOOL bFreeReq;
   char * buffer = hb_itemString( hb_param( 1, HB_IT_ANY ), &nLen, &bFreeReq );
   int iBytes = ap_rputs( buffer, pRequestRec );

   if( bFreeReq )
      hb_xfree( buffer );
      
   hb_retnl( iBytes );   
}

HB_FUNC( AP_FILENAME )
{
   hb_retc( szFileName );
}

HB_FUNC( AP_ARGS )
{
   hb_retc( szArgs );
}

HB_FUNC( AP_METHOD )
{
   hb_retc( szMethod );
}

HB_FUNC( AP_USERIP )
{
   hb_retc( szUserIP );
}

#pragma ENDDUMP
