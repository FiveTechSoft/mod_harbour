#ifdef _MSC_VER
   #include <windows.h>
#endif

#include <hbapi.h>

#ifdef _MSC_VER

HB_FUNC( MWRITE )
{
   void * bytes;
   HANDLE m = CreateFileMapping( INVALID_HANDLE_VALUE,
                                 NULL,
                                 PAGE_READWRITE,
                                 0, ( DWORD ) hb_parclen( 2 ),
                                 hb_parc( 1 ) );
   if( ! m )
   {
      hb_ret();
      return;
   }    

   bytes = MapViewOfFileEx( m, FILE_MAP_ALL_ACCESS, 0, 0, ( DWORD ) hb_parclen( 2 ), NULL );   

   memcpy( bytes, hb_parc( 2 ), hb_parclen( 2 ) );
   hb_retptr( m );
}

HB_FUNC( MREAD )
{
   void * bytes;
   HANDLE m = OpenFileMapping( PAGE_READONLY, FALSE, hb_parc( 1 ) );

   if( ! m )
   {
      hb_ret();
      return;
   }    

   bytes = MapViewOfFileEx( m, FILE_MAP_ALL_ACCESS, 0, 0, 0, NULL );
   hb_retc( ( const char * ) bytes );   
}

HB_FUNC( MERASE )
{
   void * bytes;
   HANDLE m = OpenFileMapping( PAGE_READONLY, FALSE, hb_parc( 1 ) );

   if( ! m )
   {
      hb_ret();
      return;
   } 

   bytes = MapViewOfFileEx( m, FILE_MAP_ALL_ACCESS, 0, 0, 0, NULL );
   UnmapViewOfFile( bytes );
   CloseHandle( m );
}

#endif