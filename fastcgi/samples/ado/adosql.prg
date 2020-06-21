#define adUseClient    3
#define adOpenStatic    3
#define adLockOptimistic    3

function Main()

  MsSqlSample()
  ? "ok"

return nil

function MSSQLSample()

  local oCn, oRs, cStr
  local cServer  := "208.91.198.196"
  local cDB      := "gnraore3_"
  local cUser    := "fwhmsdemo"
  local cPwd     := "fwh@2000#"
  local n, oField

  // Prepare Connection String
  // using default 32-bit provider installed on all windows PCs

  cStr  := "Provider=SQLOLEDB;" + ;
           "Data Source="     + cServer + ";" + ;
           "Initial Catalog=" + cDB     + ";" + ;
           "User ID="         + cUser   + ";" + ;
           "Password="        + cPwd    + ";"

  // Open Connection
  oCn = win_oleCreateObject( "ADODB.Connection" )
  WITH OBJECT oCn
     :ConnectionString := cStr
     :CursorLocation   := adUseClient
     :Open()
  END
  
  // Open RecordSet
  oRs = win_oleCreateObject( "ADODB.RecordSet" )
  WITH OBJECT oRs
     :ActiveConnection := oCn
     :Source           := "SELECT * FROM CUSTOMER"
     :CursorLocation   := adUseClient
     :CursorType       := adOpenStatic
     :LockType         := adLockOptimistic
     :Open()
  END
  for n = 0 to oRs:Fields:Count() - 1
     oField = oRs:Fields( n )
     ? oField:Name, "=", oField:Value
  next
  
  oRs:Close()
  oCn:Close()
  
return nil
