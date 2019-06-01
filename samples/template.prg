function Main()

   local oTemplate, n
   
   TEMPLATE USING oTemplate
   
   Raw text to be delivered to Apache   
   
   <?prg return Time() ?>
   
   ENDTEXT
   
   ? oTemplate:ClassName()
   ? "Total sections: ", Len( oTemplate:aSections )
   
   for n = 1 to Len( oTemplate:aSections )
      ? "section " + AllTrim( Str( n ) ) + ": " + oTemplate:aSections[ n ]
   next   
   
return nil
