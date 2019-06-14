#include '{%hb_GetEnv("HONEY_APP")%}/include/hbclass.ch'
#include '{%hb_GetEnv("HONEY_APP")%}/include/hboo.ch'

CLASS TUsers

   DATA cFile    INIT '{%hb_GetEnv("HONEY_APP")%}/data/users.dbf'
   DATA cAlias

   METHOD  New() CONSTRUCTOR
   METHOD  Load()					

ENDCLASS

METHOD New() CLASS TUsers

   USE ( ::cFile ) SHARED NEW VIA "DBFCDX"
   ::cAlias = Alias()
   ( ::cAlias )->( OrdSetFocus( 'dpt' ) )	

return Self

METHOD Load( cDpt ) CLASS TUsers

   local aRows := {}
   local aReg  := {=>}	
   local cPath := Url_Photos()
   local lFind := .T.
	
   hb_default( @cDpt, '' )
	
   if ( cDpt == 'ALL' )
      ( ::cAlias )->( dbGoTop() )
   else
      ( ::cAlias )->( dbSeek( cDpt, .t. ) )
   endif

   while lFind 
      if ( cDpt == 'ALL' )
         lFind = (  ( ::cAlias )->( !Eof() )  ) 
      else 
	 lFind = ( ( ::cAlias )->dpt == cDpt .and. ( ::cAlias )->( !Eof() ) ) 
      endif
		
      if lFind
         aReg = {=>}
	 aReg[ 'id' ] = hb_valtostr( ( ::cAlias )->id )
	 aReg[ 'name'  ] = ( ::cAlias )->name
	 aReg[ 'dpt'   ] = ( ::cAlias )->dpt
	 aReg[ 'phone' ] = hb_valtostr( ( ::cAlias )->phone )
	 aReg[ 'image' ] = AllTrim( cPath + ( ::cAlias )->image )
	 
	 AAdd( aRows, aReg )	

	( ::cAlias)->( DbSkip() )
      endif
   end 

return aRows

exit procedure CloseDb()
   DbCloseAll()
return 
