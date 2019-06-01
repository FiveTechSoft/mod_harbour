function Main()

   local oTemplate, n 
   
   TEMPLATE USING oTemplate
   
   Raw text to be delivered to Apache   
   
   <?prg return Time() ?>
   
   More raw text

   <?prg return DToS( Date() ) ?>

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
   
   ? "Result: " + oTemplate:cResult
   
return nil
