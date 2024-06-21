//-----------------------------------------------------------------------------------
// Mod_Habour Plus v1.00
// Fuente: mod_harbour.c
//-----------------------------------------------------------------------------------

#include "mh_externs.ch"
#include "mod_harbour.ch" 

#define _INC_DIR  "u:\desarrollo\comp\xc\hb\include" // Cambiar si es necesario "c:\harbour\include"

//-----------------------------------------------------------------------------------
// Variables de request

REQUESTVAR rv_hPP

//-----------------------------------------------------------------------------------
// Se ejecuta desde C por cada request para programas PRG

procedure mh_run()
    
    ErrorBlock( { | oError | mh_errorSys( oError ), Break( oError ) } )
    hb_hrbRun( HB_HRB_BIND_FORCELOCAL, mh_Compile( apr_readCode() ), ap_getArgs() )

return

//-----------------------------------------------------------------------------------
// Se ejecuta desde C por cada request para programas HRB

procedure mh_run_hrb()

    ErrorBlock( { | oError | mh_errorSys( oError ), Break( oError ) } )
    hb_hrbRun( HB_HRB_BIND_FORCELOCAL, apr_readCode(), ap_getArgs() )            

return

//-----------------------------------------------------------------------------------
// Version info

function mh_modName()    ; return _MODNAME
function mh_modVersion() ; return _MODVERSION 
function mh_modVerDate() ; return _MODVERDATE
    
//-----------------------------------------------------------------------------------  

function mh_objToStr( o )

    local hObj := { => }, aDatas := __objGetMsgList( o, .t. )
    local hPairs := { => }, aParents := __ClsGetAncestors( o:ClassH )

    AEval( aParents, { | h, n | aParents[ n ] := __ClassName( h ) } )
    hObj[ "CLASS" ] := o:ClassName()
    hObj[ "FROM" ] := aParents

    AEval( aDatas, { | cData | hPairs[ cData ] := __ObjSendMsg( o, cData ) } )
    hObj[ "DATAS" ] := hPairs
    hObj[ "METHODS" ] := __objGetMsgList( o, .f. )

return mh_hashToStr( hObj )

//-----------------------------------------------------------------------------------

function mh_hashToStr( h )

    local cResult := StrTran( StrTran( hb_JSonEncode( h, .t. ), CRLF, "<br>" ), "", "&nbsp;" )

    if Left( cResult, 2 ) == "{}"
        cResult := StrTran( cResult, "{}", "{=>}" )
    endif

return cResult

//-----------------------------------------------------------------------------------

function mh_valToStr( x )

    switch  valType( x )
    case 'C' 
    case 'M' ; return x 
    case 'N' ; return hb_nToS( x ) 
    case 'D' ; return DToC( x ) 
    case 'L' ; return if( x, ".T.", ".F." ) 
    case 'A' ; return hb_valToExp( x ) 
    case 'H' ; return mh_hashToStr( x )
    case 'O' ; return mh_objToStr( x ) 
    case 'P' ; return "(Pointer)" 
    case 'S' ; return "(Symbol)"         
    endswitch

return ""   // Es nulo o tipo no soportado 

//-----------------------------------------------------------------------------------
// Se ejecuta por cada peticion

static procedure mh_PPRules()

    if rv_hPP == nil
        rv_hPP := __pp_Init()

        if !empty( ap_getSysEnv( "HB_INCLUDE" ) )
            __pp_Path( rv_hPP, ap_getSysEnv( "HB_INCLUDE" ) )
        endif

        __pp_AddRule( rv_hPP, "#define __MODHARBOUR__" )  
        __pp_AddRule( rv_hPP, "#define CRLF hb_OsNewLine()" )
        __pp_AddRule( rv_hPP, "#xcommand static [<explist,...>]  => THREAD STATIC [<explist>]" )
        __pp_AddRule( rv_hPP, "#xcommand THREAD STATIC function <FuncName>([<params,...>]) => STAT FUNCTION <FuncName>( [<params>] )" )
        __pp_AddRule( rv_hPP, "#xcommand THREAD STATIC procedure <ProcName>([<params,...>]) => STAT PROCEDURE <ProcName>( [<params>] )" )
        __pp_AddRule( rv_hPP, "#xcommand ? [<explist,...>] => ap_echo( [<explist>,] '<br>' )" )
        __pp_AddRule( rv_hPP, "#xcommand ?? [<explist,...>] => ap_echo( [<explist>,] '' )" )
        __pp_AddRule( rv_hPP, "#xcommand TEXT <into:TO,INTO> <v> => #pragma __cstream|<v>:=%s" )
        __pp_AddRule( rv_hPP, "#xcommand TEXT <into:TO,INTO> <v> ADDITIVE => #pragma __cstream|<v>+=%s" )
        __pp_AddRule( rv_hPP, "#xcommand TEMPLATE [ USING <x> ] [ PARAMS [<v1>] [,<vn>] ] => " + ;
                                '#pragma __cstream | ap_rwrite( mh_InlinePrg( %s, [@<x>] [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )
        __pp_AddRule( rv_hPP, "#xcommand BLOCKS [ PARAMS [<v1>] [,<vn>] ] => " + ;
                                '#pragma __cstream | ap_rwrite( mh_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )
        __pp_AddRule( rv_hPP, "#xcommand BLOCKS TO <b> [ PARAMS [<v1>] [,<vn>] ] => " + ;
                                '#pragma __cstream | <b>+=mh_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )' )
        __pp_AddRule( rv_hPP, "#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }" )
        __pp_AddRule( rv_hPP, "#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->" )
        __pp_AddRule( rv_hPP, "#xcommand FINALLY => ALWAYS" )
        __pp_AddRule( rv_hPP, "#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ] => ;" + ;
                                "if <v1> == NIL ; <v1> := <x1> ; end [; if <vn> == NIL ; <vn> := <xn> ; end ]" )
    endif

return

//-----------------------------------------------------------------------------------

function mh_replaceBlocks( cCode, cStartBlock, cEndBlock, cParams, ... )

    local nStart, nEnd, cBlock, lReplaced 

    if valtype( cCode ) == 'C'
        hb_default( @cParams, "" )

        mh_setErrBlock( 'type', 'block' )
        mh_setErrBlock( 'code', cCode )
        
        lReplaced := .f.

        while( ( nStart := At( cStartBlock, cCode ) ) != 0 .and. ( nEnd := At( cEndBlock, cCode ) ) != 0 )
            cBlock := SubStr( cCode, nStart + Len( cStartBlock ), nEnd - nStart - Len( cEndBlock ) )
            mh_setErrBlock( 'error', cStartBlock + cBlock + cEndBlock )
            cCode := SubStr( cCode, 1, nStart -1 ) + mh_valToStr( Eval( &( "{ |" + cParams + "| " + cBlock + " }" ), ... ) ) + ;
                    SubStr( cCode, nEnd + Len( cEndBlock ) )
            lReplaced := .t.
        end

        mh_cleanErrBlock()

        return if( hb_PIsByRef( 1 ), lReplaced, cCode )
    endif

return ""

//----------------------------------------------------------------------------------- ########## Meter esta funcion como metodo de la clase TTemplate

 function mh_inlinePRG( cText, oTemplate, cParams, ... )

    local nStart, nEnd, cCode, cResult

    if PCount() > 1
        oTemplate := mh_TTemplate()

        if PCount() > 2
            oTemplate:setParams( cParams )
        endif

        while( ( nStart := At( "<?prg", cText ) ) != 0 )
                nEnd := At( "?>", SubStr( cText, nStart + 5 ) )
                cCode := SubStr( cText, nStart + 5, nEnd - 1 )
                oTemplate:addSection( cCode )
                cText := SubStr( cText, 1, nStart - 1 ) + ( cResult := mh_ExecInline( cCode, cParams, ... ) ) + ;
                        SubStr( cText, nStart + nEnd + 6 )
                oTemplate:AddResult( cResult ) 
        end 

        if oTemplate != nil
            oTemplate:setOutput( cText )
        endif    
    else
        while( ( nStart := At( "<?prg", cText ) ) != 0 )
                nEnd := At( "?>", SubStr( cText, nStart + 5 ) )
                cCode := SubStr( cText, nStart + 5, nEnd - 1 )
                cText := SubStr( cText, 1, nStart - 1 ) + mh_ExecInline( cCode, cParams, ... ) + ;
                         SubStr( cText, nStart + nEnd + 6 )
        end
    endif
 
return cText

//-----------------------------------------------------------------------------------    
// Compila un PRG

static function mh_Compile( cCode )

    mh_PPRules()
    mh_ReplaceBlocks( @cCode, "{%", "%}" )

return hb_CompileFromBuf( __pp_Process( rv_hPP, cCode ), .t., "-n", "-q2", "-I" + ;
                          _INC_DIR, "-I" + ap_getSysEnv( "HB_INCLUDE" ), ;
                          ap_getSysEnv( "HB_USER_PRGFLAGS" ) )

//-----------------------------------------------------------------------------------
// Eujecuta codigo en linea

static procedure mh_ExecInline( cCode, cParams, ... )

    if ValType( cParams ) != 'C'
        cParams := ""
    endif

    hb_hrbRun( HB_HRB_BIND_FORCELOCAL, mh_Compile( "function __Inline( " + cParams + " )" + ;
                                                   hb_osNewLine() + cCode ), ... ) 

return 

//----------------------------------------------------------------------------------- 