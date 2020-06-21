#xcommand @ <nRow>, <nCol> SAY <cPrompt> GET <uVar> [<type: PASSWORD>] => ;
             CtrlAt( <nRow>, <nCol>, <cPrompt> );;
             CtrlAt( <nRow>, <nCol> + 1, "[" + <uVar> + "]", [<(type)>] )

#xcommand @ <nRow>, <nCol> SAY <cPrompt> => ;
             CtrlAt( <nRow>, <nCol>, <cPrompt> )

#xcommand @ <nRow>, <nCol> BUTTON <cPrompt> [ <type: SUBMIT, CANCEL> ] => ;
             CtrlAt( <nRow>, <nCol>, "{" + <cPrompt> + "}", [<(type)>] )

#xcommand READ => Read()             

static aScreen := {}, aStyles := {}, nColSize := 100

//----------------------------------------------------------------------------//

function Main()

   @ 5, 2 SAY "Username:" GET "username"
   
   @ 6, 2 SAY "Login:" GET "login" PASSWORD
   
   @ 8, 3 BUTTON "Ok" SUBMIT
   
   @ 8, 4 BUTTON "Cancel" CANCEL
   
   @ 10, 3 SAY "Please identify"
   
   READ
    
return nil

//----------------------------------------------------------------------------//

function CtrlAt( nRow, nCol, cPrompt, cStyle )

   local n

   if Len( aScreen ) < nRow
      aScreen = ASize( aScreen, nRow )
      AEval( aScreen, { | aRow, nRow | If( Empty( aRow ), aScreen[ nRow ] := {},) } )
      aStyles = ASize( aStyles, nRow )
      AEval( aStyles, { | aRow, nRow | If( Empty( aRow ), aStyles[ nRow ] := {},) } )
   endif   

   for n = 1 to Len( aScreen )
      if Len( aScreen[ n ] ) < nCol
         aScreen[ n ] = ASize( aScreen[ n ], nCol + 1 )
      endif   
      if Len( aStyles[ n ] ) < nCol
         aStyles[ n ] = ASize( aStyles[ n ], nCol + 1 )
      endif   
   next
   
   aScreen[ nRow, nCol ] = cPrompt
   
   if cStyle != nil
      aStyles[ nRow, nCol ] = cStyle
   endif   

return nil
   
//----------------------------------------------------------------------------//

function Read()
   
   local nRow, nCol, cGrid := ""
   
   cGrid += '<form action="postpairs.prg" method="post">'
   
   for nRow = 1 to Len( aScreen )
      cGrid += "<table>"
      cGrid += "   <tr>"
      for nCol = 1 to Len( aScreen[ nRow ] )
         cGrid += '      <td width="' + AllTrim( Str( nColSize ) ) + '" style="width:' + ;
                  AllTrim( Str( nColSize ) ) + 'px;min-width:' + AllTrim( Str( nColSize ) ) + 'px;">' + ;
                  If( nCol == 1, AllTrim( Str( nRow ) ), ;
                  If( ! Empty( aScreen[ nRow, nCol ] ), GenHtml( aScreen[ nRow, nCol ], aStyles[ nRow, nCol ] ),;
                  If( nRow == 1, AllTrim( Str( nCol ) ), "" ) ) ) + "</td>"
      next   
      cGrid += "   </tr>"
      cGrid += "</table>"
   next
   
   cGrid += "</form>"

   ?? cGrid

return nil

//----------------------------------------------------------------------------//

function GenHtml( cText, cStyle )

   local cResult := cText

   do case
      case Left( cText, 1 ) == "["
           cResult = '<input type="' + If( ! Empty( cStyle ), cStyle, "text" ) + '"' + ;
                     ' style="width:' + AllTrim( Str( ( nColSize * 2 ) - 15 ) ) + 'px"' + ;
                     ' name="' + SubStr( cText, 2, Len( cText ) - 2 ) + '">'
           
      case Left( cText, 1 ) == "{"
           if ! Empty( cStyle ) .and. Upper( cStyle ) == "CANCEL"
              cResult = '<button type="button" onclick="location.reload();"' + ;
                        ' style="width:' + AllTrim( Str( nColSize - 20 ) ) + 'px">' + ;
                        SubStr( cText, 2, Len( cText ) - 2 ) + "</button>"
           else             
              cResult = '<button type="' + If( ! Empty( cStyle ), cStyle, "button" ) + ;
                        '" style="width:' + AllTrim( Str( nColSize - 20 ) ) + 'px">' + ;
                        SubStr( cText, 2, Len( cText ) - 2 ) + "</button>"
           endif             
   endcase
   
return cResult   

//----------------------------------------------------------------------------//
