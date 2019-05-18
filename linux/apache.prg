#pragma BEGINDUMP

#include <hbapi.h>



#include <hbvm.h>



static void * pRequestRec, * pAPRPuts;

static char * szFileName, * szArgs;



int hb_apache( void * p1, void * p2, char * cFileName, char * cArgs )

{
   
   pRequestRec = p1;
   
   pAPRPuts    = p2; 
   
   szFileName  = cFileName;
   
   szArgs      = cArgs;

   
   
   hb_vmInit( HB_TRUE );
   
   return hb_vmQuit();

}   



HB_FUNC( AP_RPUTS )

{
   
   int ( * ap_rputs )( const char * s, void * r ) = pAPRPuts;

   

   ap_rputs( hb_parc( 1 ), pRequestRec );

}



HB_FUNC( AP_FILENAME )

{
   
   hb_retc( szFileName );

}



HB_FUNC( AP_ARGS )

{
   
   hb_retc( szArgs );

}



#pragma ENDDUMP