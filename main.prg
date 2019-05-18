#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF hb_OsNewLine()

extern Version
extern hb_BuildDate
extern OS
extern hb_Compiler
extern rddList
extern AEval

//----------------------------------------------------------------//

function Main()

   ErrorSys( { | o | AP_RPuts( GetErrorInfo( o ) ) } )

   AP_SetContentType( "text/html" )

   if File( AP_FileName() )
      Execute( MemoRead( AP_FileName() ), AP_Args() )
   else
      ? "File not found: " + AP_FileName()
   endif   

return nil

//----------------------------------------------------------------//

function Alert( x )

return AP_RPuts( x ) 

//----------------------------------------------------------------//

function Execute( cCode, ... )

   local oHrb, cResult, bOldError, uRet
   local cHBheaders := "c:\harbour\include"

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

static function DoBreak( oError )

   ? GetErrorInfo( oError )

   BREAK

return nil

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
           
      otherwise
           cResult = "type not supported yet in function ValToChar()"
   endcase
   
return cResult   

//----------------------------------------------------------------//

function FHtmlEncode( cString )

   local nI, cI, cRet := ""

   for nI := 1 to Len( cString )
      cI := SubStr( cString, nI, 1 )
      if cI == "<"
         cRet += "&lt;"
      elseif cI == ">"
         cRet += "&gt;"
      elseif cI == "&"
         cRet += "&amp;"
      elseif cI == '"'
         cRet += "&quot;"
      else
         cRet += cI
      endif
   next nI

return cRet

//----------------------------------------------------------------------------//
