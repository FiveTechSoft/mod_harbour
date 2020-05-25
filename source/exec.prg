/*
**  exec.prg -- Execution module
**
** (c) FiveTech Software SL, 2019-2020
** Developed by Antonio Linares alinares@fivetechsoft.com
** MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

#include "hbclass.ch"

static hPP

//----------------------------------------------------------------//

function AddPPRules()

   if hPP == nil
      hPP = __pp_init()
      __pp_path( hPP, "~/harbour/include" )
      __pp_path( hPP, "c:\harbour\include" )
      if ! Empty( hb_GetEnv( "HB_INCLUDE" ) )
         __pp_path( hPP, hb_GetEnv( "HB_INCLUDE" ) )
      endif 	 
   endif

   __pp_addRule( hPP, "#xcommand ? [<explist,...>] => AP_RPuts( '<br>' [,<explist>] )" )
   __pp_addRule( hPP, "#xcommand ?? [<explist,...>] => AP_RPuts( [<explist>] )" )
   __pp_addRule( hPP, "#define CRLF hb_OsNewLine()" )
   __pp_addRule( hPP, "#xcommand TEXT <into:TO,INTO> <v> => #pragma __cstream|<v>:=%s" )
   __pp_addRule( hPP, "#xcommand TEXT <into:TO,INTO> <v> ADDITIVE => #pragma __cstream|<v>+=%s" )
   __pp_addRule( hPP, "#xcommand TEMPLATE [ USING <x> ] [ PARAMS [<v1>] [,<vn>] ] => " + ;
                      '#pragma __cstream | AP_RPuts( InlinePrg( %s, [@<x>] [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )
   __pp_addRule( hPP, "#xcommand BLOCKS [ PARAMS [<v1>] [,<vn>] ] => " + ;
                      '#pragma __cstream | AP_RPuts( ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )   
   __pp_addRule( hPP, "#command ENDTEMPLATE => #pragma __endtext" )
   __pp_addRule( hPP, "#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }" )
   __pp_addRule( hPP, "#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->" )
   __pp_addRule( hPP, "#xcommand FINALLY => ALWAYS" )
   __pp_addRule( hPP, "#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ] => ;" + ;
                      "IF <v1> == NIL ; <v1> := <x1> ; END [; IF <vn> == NIL ; <vn> := <xn> ; END ]" )
		      
return nil

//----------------------------------------------------------------//

function ExecuteHrb( oHrb, cArgs )

   ErrorBlock( { | oError | AP_RPuts( GetErrorInfo( oError ) ), Break( oError ) } )

return hb_HrbDo( oHrb, cArgs )

//----------------------------------------------------------------//

function Execute( cCode, ... )

   local oHrb, uRet, lReplaced := .T.
   local cHBheaders1 := "~/harbour/include"
   local cHBheaders2 := "c:\harbour\include"

   ErrorBlock( { | oError | AP_RPuts( GetErrorInfo( oError, @cCode ) ), Break( oError ) } )

   while lReplaced 
      lReplaced = ReplaceBlocks( @cCode, "{%", "%}" )
      cCode = __pp_process( hPP, cCode )
   end

   oHrb = HB_CompileFromBuf( cCode, .T., "-n", "-I" + cHBheaders1, "-I" + cHBheaders2,;
                             "-I" + hb_GetEnv( "HB_INCLUDE" ), hb_GetEnv( "HB_USER_PRGFLAGS" ) )
   if ! Empty( oHrb )
      uRet = hb_HrbDo( hb_HrbLoad( 1, oHrb ), ... )
   endif

return uRet

//----------------------------------------------------------------//

procedure DoBreak( oError )

   ? GetErrorInfo( oError )

   BREAK

//----------------------------------------------------------------//

function InlinePRG( cText, oTemplate, cParams, ... )

   local nStart, nEnd, cCode, cResult

   if PCount() > 1
      oTemplate = Template()
      if PCount() > 2
         oTemplate:cParams = cParams
      endif   
   endif   

   while ( nStart := At( "<?prg", cText ) ) != 0
      nEnd  = At( "?>", SubStr( cText, nStart + 5 ) )
      cCode = SubStr( cText, nStart + 5, nEnd - 1 )
      if oTemplate != nil
         AAdd( oTemplate:aSections, cCode )
      endif   
      cText = SubStr( cText, 1, nStart - 1 ) + ( cResult := ExecInline( cCode, cParams, ... ) ) + ;
              SubStr( cText, nStart + nEnd + 6 )
      if oTemplate != nil
         AAdd( oTemplate:aResults, cResult )
      endif   
   end 
   
   if oTemplate != nil
      oTemplate:cResult = cText
   endif   
   
return cText

//----------------------------------------------------------------//

function ExecInline( cCode, cParams, ... )

   if cParams == nil
      cParams = ""
   endif   

return Execute( "function __Inline( " + cParams + " )" + HB_OsNewLine() + cCode, ... )   

//----------------------------------------------------------------//

function ReplaceBlocks( cCode, cStartBlock, cEndBlock, cParams, ... )

   local nStart, nEnd, cBlock
   local lReplaced := .F.
   
   hb_default( @cStartBlock, "{{" )
   hb_default( @cEndBlock, "}}" )
   hb_default( @cParams, "" )

   while ( nStart := At( cStartBlock, cCode ) ) != 0 .and. ;
         ( nEnd := At( cEndBlock, cCode ) ) != 0
      cBlock = SubStr( cCode, nStart + Len( cStartBlock ), nEnd - nStart - Len( cEndBlock ) )
      cCode = SubStr( cCode, 1, nStart - 1 ) + ;
              ValToChar( Eval( &( "{ |" + cParams + "| " + cBlock + " }" ), ... ) ) + ;
      SubStr( cCode, nEnd + Len( cEndBlock ) )
          lReplaced = .T.
   end
   
return If( HB_PIsByRef( 1 ), lReplaced, cCode )

//----------------------------------------------------------------//

CLASS Template

   DATA aSections INIT {}
   DATA aResults  INIT {}
   DATA cParams   
   DATA cResult

ENDCLASS

//----------------------------------------------------------------//

function LoadHRB( cHrbFile_or_oHRB )

   local lResult := .F.

   if ValType( cHrbFile_or_oHRB ) == "C"
      if File( hb_GetEnv( "PRGPATH" ) + "/" + cHrbFile_or_oHRB )
         AAdd( M->getList,;
            hb_HrbLoad( 1, hb_GetEnv( "PRGPATH" ) + "/" + cHrbFile_or_oHRB ) )
         lResult = .T.   
      endif      
   endif
   
   if ValType( cHrbFile_or_oHRB ) == "P"
      AAdd( M->getList, hb_HrbLoad( 1, cHrbFile_or_oHRB ) )
      lResult = .T.
   endif
   
return lResult   

//----------------------------------------------------------------//
