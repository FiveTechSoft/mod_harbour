function Main()

   LocalStorageSetItem( "Name", "Taavi" ) 

return nil  

function LocalStorageSetItem( cKey, cValue )

return AP_RPuts( "<script>localStorage.setItem( '" + cKey + "','" + cValue + "')</script>" )
