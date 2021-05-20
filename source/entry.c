#include <hbapi.h>
#include <hbvm.h>

static void * pRequestRec;

HB_EXPORT_ATTR int hb_apache( void * _pRequestRec )
{
   pRequestRec = _pRequestRec;
 
   hb_vmInit( HB_TRUE );
   return hb_vmQuit();
}   

void * GetRequestRec( void )
{
   return pRequestRec;
}

HB_FUNC( AP_ENTRY )
{
   hb_apache( NULL );
}   
