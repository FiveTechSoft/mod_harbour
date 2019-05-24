#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

extern AP_HEADERSINCOUNT, AP_HEADERSINKEY, AP_HEADERSINVAL, AP_METHOD, AP_ARGS, AP_USERIP

//----------------------------------------------------------------//

function _AppMain()

   ErrorBlock( { | o | AP_RPuts( GetErrorInfo( o ) ), .F. } )

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
           
      case cType == "U"
           cResult = "nil"

      otherwise
           cResult = "type not supported yet in function ValToChar()"
   endcase
   
return cResult   

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>
#include <hbapiitm.h>

static void * pRequestRec, * pAPRPuts;
static void * pHeadersIn, * pHeadersOut, * pHeadersInCount, * pHeadersInKey, * pHeadersInVal;
static const char * szFileName, * szArgs, * szMethod, * szUserIP;

int hb_apache( void * _pRequestRec, void * _pAPRPuts, 
               const char * cFileName, const char * cArgs, const char * cMethod, const char * cUserIP,
               void * _pHeadersIn, void * _pHeadersOut, 
               void * _pHeadersInCount, void * _pHeadersInKey, void * _pHeadersInVal )
{
   pRequestRec     = _pRequestRec;
   pAPRPuts        = _pAPRPuts; 
   szFileName      = cFileName;
   szArgs          = cArgs;
   szMethod        = cMethod;
   szUserIP        = cUserIP;
   pHeadersIn      = _pHeadersIn;
   pHeadersOut     = _pHeadersOut;
   pHeadersInCount = _pHeadersInCount;
   pHeadersInKey   = _pHeadersInKey;
   pHeadersInVal   = _pHeadersInVal;
 
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

HB_FUNC( AP_HEADERSINCOUNT )
{
   int ( * headers_in_count )( void ) = pHeadersInCount;
   
   hb_retnl( headers_in_count() );
}   

HB_FUNC( AP_HEADERSINKEY )
{
   char * ( * headers_in_key )( int ) = pHeadersInKey;
   
   hb_retc( headers_in_key( hb_parnl( 1 ) ) );
}   

HB_FUNC( AP_HEADERSINVAL )
{
   char * ( * headers_in_val )( int ) = pHeadersInVal;
   
   hb_retc( headers_in_val( hb_parnl( 1 ) ) );
}   

#pragma ENDDUMP
