function Main()

   local oTemplate, n, x := "first", y := "second", z := "third" 
   
   TEMPLATE USING oTemplate PARAMS x, y, z
   
   Raw text to be delivered to Apache   
   
   <?prg return x ?>
   
   More raw text

   <?prg return DToS( Date() ) + y ?>

   ENDTEXT
   
   ? 
   ? oTemplate:ClassName()
   ? "Total sections: ", Len( oTemplate:aSections )
   ? 
   
   for n = 1 to Len( oTemplate:aSections )
      ? "section", n, ": " + oTemplate:aSections[ n ]
      ? "result ", n, ": " + oTemplate:aResults[ n ]
      ? 
   next   
   
   ? "Params: " + oTemplate:cParams
   ? "Result: " + oTemplate:cResult
   
return nil
