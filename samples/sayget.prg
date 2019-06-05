#xcommand @ <nRow>, <nCol> SAY <cPrompt> [ GET <uVar> ] => ;
             CtrlAt( <nRow>, <nCol>, <cPrompt> ) [; CtrlAt( <nRow>, <nCol> + 1, "[" + <uVar> + "]" ) ]

#xcommand @ <nRow>, <nCol> BUTTON <cPrompt> => CtrlAt( <nRow>, <nCol>, "{" + <cPrompt> + "}" )

#xcommand READ => Read()             

static aScreen := {}

//----------------------------------------------------------------------------//

function Main()

   @ 5, 5 SAY "Username:"
   
   @ 6, 5 SAY "Login:"
   
   @ 8, 6 BUTTON "Ok"
   
   @ 8, 8 BUTTON "Cancel"
   
   @ 10, 5 SAY "Please identify"
   
   READ
    
return nil

//----------------------------------------------------------------------------//

function CtrlAt( nRow, nCol, cPrompt )

   local n

   if Len( aScreen ) < nRow
      aScreen = ASize( aScreen, nRow )
      AEval( aScreen, { | aRow, nRow | If( Empty( aRow ), aScreen[ nRow ] := {},) } )
   endif   

   for n = 1 to Len( aScreen )
      if Len( aScreen[ n ] ) < nCol
         aScreen[ n ] = ASize( aScreen[ n ], nCol )
      endif   
   next
   
   aScreen[ nRow, nCol ] = cPrompt

return nil
   
//----------------------------------------------------------------------------//

function Read()
   
   local nRow, nCol, cGrid := ""
   
   for nRow = 1 to Len( aScreen )
      cGrid += "<table>"
      cGrid += "   <tr>"
      for nCol = 1 to Len( aScreen[ nRow ] )
         cGrid += '      <td width="47" style="width:47px;min-width:47px;">' + ;
                  If( nCol == 1, AllTrim( Str( nRow ) ), ;
                  If( ! Empty( aScreen[ nRow, nCol ] ), GenHtml( aScreen[ nRow, nCol ] ),;
                  If( nRow == 1, AllTrim( Str( nCol ) ), "" ) ) ) + "</td>"
      next   
      cGrid += "   </tr>"
      cGrid += "</table>"
   next

   ?? cGrid

return nil

//----------------------------------------------------------------------------//

function GenHtml( cText )

   local cResult := cText

   do case
      case Left( cText, 1 ) == "["
           cResult = '<input type="text" name="' + SubStr( cText, 2, Len( cText ) - 2 ) + '">'
           
      case Left( cText, 1 ) == "{"
           cResult = '<button type="button">' + SubStr( cText, 2, Len( cText ) - 2 ) + "</button>"
   endcase
   
return cResult   

//----------------------------------------------------------------------------//
