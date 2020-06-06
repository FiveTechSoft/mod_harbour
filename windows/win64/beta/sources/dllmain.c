#include <windows.h>
#include <hbapi.h>
#include <hbvm.h>

BOOL APIENTRY DllMain( HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved )
{
    hModule = hModule;
    lpReserved = lpReserved;

    switch( ul_reason_for_call )
    {
       case DLL_PROCESS_ATTACH:
            hb_vmInit( HB_FALSE );
            break;
  
       case DLL_THREAD_ATTACH:
            break;
 
       case DLL_THREAD_DETACH:
            break;

       case DLL_PROCESS_DETACH:
            hb_vmQuit();
            break;
    }
    return TRUE;
}