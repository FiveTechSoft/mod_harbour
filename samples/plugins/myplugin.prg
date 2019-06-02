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

typedef void ( * HB_VM_EXECUTE )( const HB_BYTE * pCode, PHB_SYMB pSymbols );

static HB_VM_EXECUTE vmExecute = NULL;

void hb_init( void * _vmProcessSymbols, void * _vmExecute )
{
   vmProcessSymbols = _vmProcessSymbols;
   vmExecute = _vmExecute;
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

void hb_vmExecute( const HB_BYTE * pCode, PHB_SYMB pSymbols )
{
   if( vmExecute != NULL )
      vmExecute( pCode, pSymbols );   
}

#pragma ENDDUMP
