// This example is called from samples/do.prg

function Main()

   local hValues, cFunction, aParams, cParams := "(" 

   hb_jsonDecode( AP_Body(), @hValues )

   if ! hb_HHasKey( hValues, "function" )
      return nil
   endif

   cFunction = hValues[ "function" ]
   aParams   = hValues[ "params" ] 
   
   AEval( aParams, { | u | cParams += ValToChar( u ) + "," } )
   cParams = SubStr( cParams, 1, Len( cParams ) - 1 ) + ")"

   ?? &( hValues[ "function" ] + cParams )

return nil   

function Test( n1, n2 )

return n1 + n2
