//----------------------------------------------------------------------------------- 

#include "mod_harbour.ch"

//-----------------------------------------------------------------------------------

REQUESTVAR rv_hErrBlock := { => }
REQUESTVAR rv_bError

//-----------------------------------------------------------------------------------

procedure mh_errorSys( oError, cCode, cCodePP )

    local hError

    hb_default( @cCode, "" )
    hb_default( @cCodePP, "" )

    hError := mh_errorInfo( oError, cCode, cCodePP )

    if ValType( rv_bError ) == 'B'
        Eval( rv_bError, hError )
    else
        mh_errorShow( hError )
    endif

return

//-----------------------------------------------------------------------------------

function mh_setErrorBlock( bBlockError )

    local bErrorOld := rv_bError

    rv_bError := bBlockError

return bErrorOld

//-----------------------------------------------------------------------------------

procedure mh_doError( cDescription, cSubsystem, nSubCode )

    local oError := ErrorNew()

    hb_default( @cSubsystem, "Mod_HarbourPlus" )
    hb_default( @nSubCode, 0 )

    oError:Subsystem := cSubsystem
    oError:SubCode := nSubCode
    oError:Severity := ES_ERROR
    oError:Description := cDescription

    Eval( ErrorBlock(), oError )

return

//-----------------------------------------------------------------------------------

function mh_errorInfo( oError, cCode, cCodePP )

    local aTagLine := {}
    local n, aLines, cLine, nPos, nL, nLin, nOffset, lReview, cInfo, nLen
    local hError := { => }

    hError[ 'date' ] := DToC( Date() )
    hError[ 'time' ] := time()
    hError[ 'description' ] := ""
    hError[ 'operation' ] := ""
    hError[ 'filename' ] := ""
    hError[ 'subsystem' ] := ""
    hError[ 'subcode' ] := ""
    hError[ 'args' ] := {}
    hError[ 'stack' ] := {}
    hError[ 'line' ] := 0
    hError[ 'type' ] := ""
    hError[ 'block_code' ] := ""
    hError[ 'block_error' ] := ""
    hError[ 'code' ] := cCode
    hError[ 'codePP' ] := cCodePP

    if !empty( rv_hErrBlock )
        hError[ 'type' ] := rv_hErrBlock[ 'type' ]

        switch hError[ 'type' ]
        case 'block'
            hError[ 'block_code' ] := rv_hErrBlock[ 'code' ]
            hError[ 'block_error' ] := rv_hErrBlock[ 'error' ]
			exit

        case 'initprocess'
            hError[ 'filename' ] := rv_hErrBlock[ 'filename' ]
			exit

        endswitch
    endif

    hError[ 'description' ] := oError:description

    if !Empty( oError:operation )
        if substr( oError:operation, 1, 5 ) != 'line:'
            hError[ 'operation' ] := oError:operation
        endif
    endif

    if !Empty( oError:filename )
        hError[ 'filename' ] := oError:filename
    endif

    if !Empty( oError:subsystem )
        hError[ 'subsystem' ] := oError:subsystem

        if !empty( oError:subcode )
            hError[ 'subcode' ] :=  mh_valToStr( oError:subcode )
        endif
    endif

    // Buscamos tags #line (#includes,#commands,...)
    aLines := hb_ATokens( cCodePP, chr( 10 ) )
    nLen := Len( aLines )

    for n := 1 to nLen
        cLine := aLines[ n ]

        if substr( cLine, 1, 5 ) == '#line'
            nLin := Val( Substr( cLine, 6 ) )
            AAdd( aTagLine, { n, ( nLin - n - 1 ) } )
        endif
    next

    // Buscamos si oError nos da Linea
    nL := 0

    if !Empty( oError:operation )
        nPos := At( 'line:', oError:operation )

        if nPos > 0
            nL := Val( Substr( oError:operation, nPos + 5 ) )
        endif
    endif

    // Procesamos Offset segun linea error
    hError[ 'line' ] := nL
    hError[ 'tag' ] := aTagLine

    if nL > 0
        hError[ 'line' ] := nL
        nLen := len( aTagLine )

        for n := 1  to nLen
            if aTagLine[ n ][ 1 ] < nL
                nOffset    := aTagLine[ n ][ 2 ]
                hError[ 'line' ] := nL + nOffset
            endif
        next
    endif

    if ValType( oError:Args ) == "A"
        hError[ 'args' ] := oError:Args
    endif

    n := 2
    lReview := .f.

    while !Empty( ProcName( n ) )
        cInfo := "called from: " + If( !Empty( ProcFile( n ) ), ProcFile( n ) + ", ", "" ) + ;
           ProcName( n ) + ", line: " + ;
			hb_ntos( ProcLine( n ) ) 
        AAdd( hError[ 'stack' ], cInfo )

        n++

        if nL == 0 .and. !lReview .and. ProcFile( n ) == 'pcode.hrb'
            nL := ProcLine( n )
            lReview := .t.
        endif
    end

    if lReview .and. nL > 0
        hError[ 'line' ] := nL
        nLen := len( aTagLine )

        for n := 1  to nLen
            if aTagLine[ n ][ 1 ] < nL
                nOffset    := aTagLine[ n ][ 2 ]
                hError[ 'line' ] := nL + nOffset
            endif
        next
    endif

return hError

//-----------------------------------------------------------------------------------

function mh_setErrBlock( cKey, uValue )

	local xRet

    if ValType( cKey ) == 'C'
		if hb_HHasKey( rv_hErrBlock, cKey )
			xRet := rv_hErrBlock[ cKey ]
		endif
		
        rv_hErrBlock[ cKey ] := uValue
    endif

return xRet

//-----------------------------------------------------------------------------------

procedure mh_cleanErrBlock()

	rv_hErrBlock := { => }
	
return

//-----------------------------------------------------------------------------------

procedure mh_ErrorShow( hError )

	local cHtml := ""
	local aLines, n, cTitle, cInfo, cLine, nLen
	
	cHtml += _getCss()
	cHtml += _getHeader()

	BLOCKS TO cHtml 	
		<div>
			<table>
				<tr>
					<th>Description</th>
					<th>Value</th>			
				</tr>	
	ENDTEXT

	cHtml += _getTbRow( 'Date', hError[ 'date' ] + ' ' + hError[ 'time' ] )	
	cHtml += _getTbRow( 'Description', hError[ 'description' ] )	
	
	if !empty( hError[ 'operation' ] )
		cHtml += _getTbRow( 'Operation', hError[ 'operation' ] )			
	endif	
	
	if !empty( hError[ 'line' ] )
		cHtml += _getTbRow( 'Line', hError[ 'line' ] )					
	endif
	
	if !empty( hError[ 'filename' ] )
		cHtml += _getTbRow( 'Filename', hError[ 'filename' ] )							
	endif
	
	cHtml += _getTbRow( 'System', hError[ 'subsystem' ] + if( !empty(hError[ 'subcode' ]), '/' + hError[ 'subcode' ], "") )							

	if !empty( hError[ 'args' ] )			
		cInfo := ""
        nLen := Len( hError[ 'args' ] )
	
		for n := 1 to nLen
			cInfo += "[" + hb_ntos( n ) + "] := " + ValType( hError[ 'args' ][ n ] ) + ;
					"   " + mh_valToStr( hError[ 'args' ][ n ] ) + ;
					If( ValType( hError[ 'args' ][ n ] ) == "A", " Len: " + ;
						hb_ntos( Len( hError[ 'args' ][ n ] ) ), "" ) + "<br>"
		next	
	
		cHtml += _getTbRow( 'Arguments', cInfo )									
	endif

	if !empty( hError[ 'stack' ] )	
		cInfo := ""
        nLen := Len( hError[ 'stack' ] )
	
		for n := 1 to nLen
			cInfo += hError[ 'stack' ][n] + '<br>'
		next	
	
		cHtml += _getTbRow( 'Stack', cInfo )									
	endif
	
	cHtml += '</table></div>'
	
	switch hError[ 'type' ]
	case 'block' 					
		cTitle := 'Code Block'
		cInfo := '<div class="mc_block_error"><b>Error => </b><span class="mc_line_error">' + hError[ 'block_error' ] + '</span></div>'								
		aLines := hb_ATokens( hError[ 'block_code' ], chr(10) )
		exit
	
	case "" 		
		cTitle := 'Code'
		cInfo := ""
		aLines := hb_ATokens( hError[ 'code' ], chr(10) )
		exit
			
	case 'initprocess' 					
		cTitle 	:= 'InitProcess'
		cInfo 	:= '<div class="mc_block_error"><b>Filename => </b><span class="mc_line_error">' + hError[ 'filename' ] + '</span></div>'
		aLines 	:= {}		
		exit
			
	endswitch	

    nLen := Len( aLines )
	
	for n := 1 to nLen
		cLine := aLines[ n ]
		cLine := ap_htmlEncode( cLine )  
		cLine := StrTran( cLine, chr(9), '&nbsp;&nbsp;&nbsp;' )			
	
        if hError[ 'line' ] > 0 .and. hError[ 'line' ] == n
            cInfo += '<b>' + StrZero( n, 4 ) + ' <span class="mc_line_error">' + cLine + '</span></b>'
        else			
            cInfo += StrZero( n, 4 ) + ' ' + cLine
        endif
	
		cInfo += '<br>'
	next		
		
	cHtml += '<div class="mc_container_code">'
	cHtml += ' <div class="mc_code_title">' + cTitle + '</div>'
	cHtml += ' <div class="mc_code_source">' + cInfo + '</div>'
	cHtml += '</div>'

	?? cHtml
	
return

//-----------------------------------------------------------------------------------

function mh_Logo()
return 'https://i.postimg.cc/GmJy078K/modharbour-mini.png'

//-----------------------------------------------------------------------------------

function mh_FavIcon()
return 'https://i.postimg.cc/g2HWb5Vg/favicon.png'

//-----------------------------------------------------------------------------------

static function _getTbRow( cDescription, cValue )

	local cRow := ""

	BLOCKS TO cRow PARAMS cDescription, cValue
		<tr>
			<td class="description" >{{ cDescription }}</td>
			<td class="value">{{ cValue }}</td>
		</tr>
	ENDTEXT
	
return cRow

//-----------------------------------------------------------------------------------

static function _getHeader()

    local cHeader := ""

	BLOCKS TO cHeader
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<title>ErrorSys</title>										
			<link rel="shortcut icon" type="image/png" href="{{ mh_favicon() }}"/>
		</head>		
		
		<div class="title">
			<img class="logo" src="{{ mh_logo() }}"></img>
			<p class="title_error">Error System</p>			
		</div>
		
		<hr>
	ENDTEXT
	
return cHeader

//-----------------------------------------------------------------------------------

static function _getCss()

    local cCss := ""

	BLOCKS TO cCss
		<style>
		
			body { background-color: lightgray; }
			.mc_container_code {
				width: 100%;
				border: 1px solid black;
				box-shadow: 2px 2px 2px black;
				margin-top: 10px;			
			}
			
			.mc_code_title {
				font-family: tahoma;
			    text-align: center;
				background-color: #095fa8;
				padding: 5px;
				color: white;
			}
			
			.mc_code_source {
				padding: 5px;
				font-family: monospace;
				font-size: 12px;
				background-color: #e0e0e0;				
			}
			
			.mc_line_error {
			    background-color: #9b2323;
				color: white;
			}
			
			.mc_block_error {
			    border: 1px solid black;
				padding: 5px;
				margin-bottom: 5px;
			}
			
			table { box-shadow: 2px 2px 2px black; }
			
			table, th, td {
				border-collapse: collapse;
				padding: 5px;
				font-family: tahoma;
			}
			th, td {
				border-bottom: 1px solid #ddd;
			}			
			th {
			  background-color: #095fa8;
			  color: white;
			}	
			
			tr:hover { background-color: yellow; }
			
			.title {
				width:100%;
				height:70px;
			}
			
			.title_error {
				margin-left: 20px;
				float: left;
				margin-top: 20px;
				font-size: 26px;
				font-family: sans-serif;
				font-weight: bold;
			}
			
			.logo {
				float:left;
				width: 100px;
			}
			
			.description {
				font-weight: bold;
				background-color: #8da5b1;
				text-align: right;
			}
			
			.value {				
				background-color: white;
			}			
			
		</style>
	ENDTEXT
	
return cCss

//-----------------------------------------------------------------------------------
