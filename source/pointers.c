#include <hbapi.h>

//----------------------------------------------------------------//

HB_FUNC( PTRTOSTR )
{
   #ifdef HB_ARCH_32BIT
      const char * * pStrs = ( const char * * ) hb_parnl( 1 );   
   #else
      const char * * pStrs = ( const char * * ) hb_parnll( 1 );   
   #endif

   hb_retc( * ( pStrs + hb_parnl( 2 ) ) );
}

//----------------------------------------------------------------//

HB_FUNC( PTRTOUI )
{
   #ifdef HB_ARCH_32BIT
      unsigned int * pNums = ( unsigned int * ) hb_parnl( 1 );   
   #else
      unsigned int * pNums = ( unsigned int * ) hb_parnll( 1 );   
   #endif

   hb_retnl( * ( pNums + hb_parnl( 2 ) ) );
}

//----------------------------------------------------------------//