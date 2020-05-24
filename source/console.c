#include <hbapi.h>

//----------------------------------------------------------------//

#ifdef _MSC_VER
   #pragma warning(disable:4996)
   #include <windows.h>

HB_FUNC( SHOWCONSOLE )     // to use the debugger locally on Windows
{
   ShowWindow( GetConsoleWindow(),  3 );
   ShowWindow( GetConsoleWindow(), 10 );
}

#else

HB_FUNC( SHOWCONSOLE )
{
}

#endif

//----------------------------------------------------------------//