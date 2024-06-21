//===================================================================================
// Para depuracion (solo en windows)
//===================================================================================
// Funciones de depuracion para C

#include "hbapi.h"

#if defined( HB_OS_WIN )

#include "windows.h"

//-----------------------------------------------------------------------------------

void OutStr( const char *szTxt )
{
	OutputDebugString( szTxt );
}

//-----------------------------------------------------------------------------------

void OutNum( HB_LONG lNum )
{
	char szBuffer[  80  ];

	hb_snprintf( szBuffer, 80, "%ld", lNum );
	OutputDebugString( szBuffer );
}

//-----------------------------------------------------------------------------------
// Funciones de depuracion para PRG

HB_FUNC( OUTSTR )
{
	OutStr( hb_parc( 1 ) ) ;
}

//-----------------------------------------------------------------------------------

HB_FUNC( OUTNUM )
{
	OutNum( hb_parnl( 1 ) ) ;
}

#endif
