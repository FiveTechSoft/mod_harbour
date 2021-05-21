#include <hbapi.h>
#include <hbvm.h>

static void * pRequestRec;
static void * pNgxApi;

HB_EXPORT_ATTR int hb_apache( void * _pRequestRec, void * _pNgxApi )
{
   pRequestRec = _pRequestRec;
   pNgxApi = _pNgxApi;
 
   hb_vmInit( HB_TRUE );
   return hb_vmQuit();
}   

void * GetRequestRec( void )
{
   return pRequestRec;
}

void * GetNgxApi( void )
{
   return pNgxApi;
}  

HB_FUNC( AP_ENTRY )
{
   hb_apache( NULL, NULL );
}   
