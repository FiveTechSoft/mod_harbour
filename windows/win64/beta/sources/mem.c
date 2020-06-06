/*
**  mem.c -- shared memory module
**  original idea by Chris Wellons https://nullprogram.com/blog/2016/04/10/
**  and https://gist.github.com/garcia556/8231e844a90457c99cc72e5add8388e4
**  Developed by Antonio Linares alinares@fivetechsoft.com
**  MIT license https://github.com/FiveTechSoft/mod_harbour/blob/master/LICENSE
*/

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
   UnmapViewOfFile( bytes );
   CloseHandle( m );
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
   UnmapViewOfFile( bytes );
   CloseHandle( m );    
}

#else

#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#define ignore_result(x) if (x){}

#define MEMSIZE 100

HB_FUNC( MWRITE )
{
   void * bytes;
   int fd = shm_open( ( char * ) hb_parc( 1 ), O_RDWR | O_CREAT, S_IRUSR | S_IWUSR );

   ignore_result( ftruncate( fd, MEMSIZE ) );
   bytes = mmap( NULL, MEMSIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0 );
   memcpy( bytes, hb_parc( 2 ), hb_parclen( 2 ) );
}

HB_FUNC( MREAD )
{
   void * bytes;
   int fd = shm_open( ( char * ) hb_parc( 1 ), O_RDONLY, S_IRUSR | S_IWUSR );
   
   bytes = mmap( NULL, MEMSIZE, PROT_READ, MAP_SHARED, fd, 0 );
   hb_retc( bytes );
}

#endif
