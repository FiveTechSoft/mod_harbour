#xcommand @ <nRow>, <nCol> SAY <cPrompt> [ GET <uVar> ] => ;
             SayAt( <nRow>, <nCol>, <cPrompt> ) 

//----------------------------------------------------------------------------//

function Main()

   @ 5, 5 SAY "Name:"
    
return nil

//----------------------------------------------------------------------------//

function SayAt( nRow, nCol, cPrompt )

   local cGrid := ""
   local n
   
   for n = 1 to nRow
      cGrid += "<table>"
      cGrid += "   <tr>"
      cGrid += '      <td width="47" style="width:47px;min-width:47px;">' + AllTrim( Str( n ) ) + "</td>"
      cGrid += "   </tr>"
      cGrid += "</table>"
   next

   ?? cGrid

return nil

//----------------------------------------------------------------------------//
