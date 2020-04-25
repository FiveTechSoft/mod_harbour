// This example is called from samples/do.prg

function Main()

   local hValues := AP_PostPairs()
   local cFunction, aParams 
   local cParams := "(" 

   if ! hb_HHasKey( hValues, "function" )
      return nil
   endif
   
   cFunction = hValues[ "function" ]
   aParams   = hValues[ "params" ] 
   
   AEval( aParams, { | u | cParams += ValToChar( u ) + "," } )
   cParams = SubStr( cParams, 1, Len( cParams ) - 1 ) + ")"
   
   ?? &( hParams[ "function" ] + cParams )
   
return nil   

function Test( n1, n2 )

return n1 + n2
