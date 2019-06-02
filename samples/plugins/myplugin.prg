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

static PHB_SYMB _pSymbols = NULL;
static HB_USHORT _uiSymbols = 0;
static const char * _szModuleName = NULL;
static HB_ULONG _ulID = 0;
static HB_USHORT _uiPcodeVer = 0;

PHB_SYMB hb_vmProcessSymbols( PHB_SYMB pSymbols, HB_USHORT uiSymbols,
                              const char * szModuleName, HB_ULONG ulID,
                              HB_USHORT uiPcodeVer )
{
   if( vmProcessSymbols != NULL )
      return vmProcessSymbols( pSymbols, uiSymbols, szModuleName, ulID, uiPcodeVer );
   else
   {
      _pSymbols     = pSymbols;
      _uiSymbols    = uiSymbols;
      _szModuleName = szModuleName;
      _ulID         = ulID;
      _uiPcodeVer   = uiPcodeVer;
      
      return NULL;  
   }   
}

void hb_init( void * _vmProcessSymbols, void * _vmExecute )
{
   vmProcessSymbols = _vmProcessSymbols;
   vmExecute        = _vmExecute;
   hb_vmProcessSymbols( _pSymbols, _uiSymbols, _szModuleName, _ulID, _uiPcodeVer );
}

void hb_vmExecute( const HB_BYTE * pCode, PHB_SYMB pSymbols )
{
   if( vmExecute != NULL )
      vmExecute( pCode, pSymbols );   
}

#pragma ENDDUMP
