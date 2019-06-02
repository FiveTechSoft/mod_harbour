function Test()

return 123

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>

typedef PHB_SYMB ( * HB_VM_PROCESS_SYMBOLS )
   ( PHB_SYMB pModuleSymbols, HB_USHORT uiModuleSymbols,
   const char * szModuleName, HB_ULONG ulID,
   HB_USHORT uiPcodeVer );

static HB_VM_PROCESS_SYMBOLS vmProcessSymbols = NULL;

void hb_init( void * _vmProcessSymbols )
{
   vmProcessSymbols = _vmProcessSymbols;
}

PHB_SYMB hb_vmProcessSymbols( PHB_SYMB pSymbols, HB_USHORT uiSymbols,
                              const char * szModuleName, HB_ULONG ulID,
                              HB_USHORT uiPcodeVer )
{
   if( vmProcessSymbols != NULL )
      return vmProcessSymbols( pSymbols, uiSymbols, szModuleName, ulID, uiPcodeVer );
   else
      return NULL;   
}

#pragma ENDDUMP 
