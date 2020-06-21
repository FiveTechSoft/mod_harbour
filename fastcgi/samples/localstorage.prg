function Main()

   LocalStorageSetItem( "Name", "Taavi" ) 

   ShowLocalStorageItem( "Name" )

return nil  

function LocalStorageSetItem( cKey, cValue )

return AP_RPuts( "<script>localStorage.setItem( '" + cKey + "','" + cValue + "')</script>" )

function ShowLocalStorageItem( cKey )

return AP_RPuts( "<script>alert( localStorage.getItem( '" + cKey + "') )</script>" )
