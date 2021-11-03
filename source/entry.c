#include <Windows.h>
#include <hbapi.h>
#include <hbvm.h>

static void * pRequestRec;

HB_EXPORT_ATTR int hb_apache( void * _pRequestRec )
{
   int iResult;

   pRequestRec = _pRequestRec;
 
   hb_vmInit( HB_TRUE );
   OutputDebugString( "after hb_vmInit()\n" );
   iResult = hb_vmQuit();
   OutputDebugString( "after hb_vmQuit()\n" );
   return iResult;
}   

void * GetRequestRec( void )
{
   return pRequestRec;
}

HB_FUNC( AP_ENTRY )
{
   hb_apache( NULL );
}   
