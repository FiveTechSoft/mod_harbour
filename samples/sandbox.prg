function Main()

   local n

   USE "/var/www/test/customer.dbf"

   ? "Alias: " + Alias()
   ? "Number of records: " + Str( RecCount() )   
   ? "****************************************"
   ? "Fields names"

   for n = 1 to FCount()
      ? Str( n ) + ": " + FieldName( n )
   next
   ? "****************************************"

return nil
