#xcommand @ <nRow>, <nCol> SAY <cPrompt> [ GET <uVar> ] => ;
             SayAt( <nRow>, <nCol>, <cPrompt> ) 

function Main()

   @ 5, 5 SAY "Name:"
    
return nil

function SayAt( nRow, nCol, cPrompt )

   local cGrid := ""
   local n
   
   for n = 1 to n
      cGrid += "<table>"
      cGrid += "</table>"
   next

   ? cGrid

return nil
