//-----------------------------------------------------------------------------
// Funciones interfaces APR LIB
//-----------------------------------------------------------------------------

#include "mod_harbour.h"

//-----------------------------------------------------------------------------
// Hace un bloqueo usando el mutex general

HB_FUNC( APR_LOCK )
{
	hb_retl( apr_thread_mutex_lock( pGD->lock ) == APR_SUCCESS );
}

//-----------------------------------------------------------------------------
// Intenta hacer un bloqueo usando el mutex general

HB_FUNC( APR_TRYLOCK )
{
	hb_retl( apr_thread_mutex_trylock( pGD->lock ) == APR_SUCCESS );
}

//-----------------------------------------------------------------------------
// Dloquea el mutex general

HB_FUNC( APR_UNLOCK )
{
	hb_retl( apr_thread_mutex_unlock( pGD->lock ) == APR_SUCCESS );
}

//----------------------------------------------------------------------------
// Crea un mutex en el request. Devuelve el puntero al mismo.

HB_FUNC( APR_MUTEXCREATE )
{
	apr_thread_mutex_t *mutex;

	if( apr_thread_mutex_create( &mutex, APR_THREAD_MUTEX_NESTED, getReqRecPtr()->pool ) != APR_SUCCESS )
	{
		mutex = NULL;
	}

	hb_retptr( mutex );
}

//----------------------------------------------------------------------------
// Hace un bloqueo con el mutex creado

HB_FUNC( APR_MUTEXLOCK )
{
	apr_thread_mutex_t *mutex = hb_parptr( 1 );

	if( mutex )
	{
		hb_retl( apr_thread_mutex_lock( mutex ) == APR_SUCCESS );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

//-----------------------------------------------------------------------------
// Intenta bloqueo con el mutex creado

HB_FUNC( APR_MUTEXTRYLOCK )
{
	apr_thread_mutex_t *mutex = hb_parptr( 1 );

	if( mutex )
	{
		hb_retl( apr_thread_mutex_trylock( mutex ) == APR_SUCCESS );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

//-----------------------------------------------------------------------------
// Dloquea con el mutex creado

HB_FUNC( APR_MUTEXUNLOCK )
{
	apr_thread_mutex_t *mutex = hb_parptr( 1 );

	if( mutex )
	{
		hb_retl( apr_thread_mutex_unlock( mutex ) == APR_SUCCESS );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

//-----------------------------------------------------------------------------
// Hace un bloqueo con el mutex creado

HB_FUNC( APR_MUTEXDESTROY )
{
	apr_thread_mutex_t *mutex = hb_parptr( 1 );

	if( mutex )
	{
		hb_retl( apr_thread_mutex_destroy( mutex ) == APR_SUCCESS );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

//-----------------------------------------------------------------------------
// Now, in microseconds

HB_FUNC( APR_TIMENOW )
{
	hb_retnint( ( HB_MAXINT ) apr_time_now() );
}

//-----------------------------------------------------------------------------
// one day, in microseconds

HB_FUNC( APR_MSECONEDAY )
{
	hb_retnint( ( 86400 * APR_USEC_PER_SEC ) );
}

//-----------------------------------------------------------------------------
// one hour, in microseconds

HB_FUNC( APR_MSECONEHR )
{
	hb_retnint( ( 3600 * APR_USEC_PER_SEC ) );
}

//-----------------------------------------------------------------------------
// one minute, in microseconds

HB_FUNC( APR_MSECONEMIN )
{
	hb_retnint( ( 60 * APR_USEC_PER_SEC ) );
}

//-----------------------------------------------------------------------------
// one second, in microseconds

HB_FUNC( APR_MSECONESEC )
{
	hb_retnint( ( APR_USEC_PER_SEC ) );
}

//-----------------------------------------------------------------------------
// Formatted date

HB_FUNC( APR_HTTIME )
{
	apr_time_t tTime = ( apr_time_t ) hb_parnintdef( 1, ( HB_MAXINT ) apr_time_now() );
	const char *szFormat = hb_parc( 2 );
	int iGMT = hb_parnidef( 3, 0 );

	if( !szFormat )
	{
		szFormat = "%A, %d-%b-%Y %H:%M:%S %Z";
	}

	hb_retc( ap_ht_time( getReqRecPtr()->pool, tTime, szFormat, iGMT ) );
}

//-----------------------------------------------------------------------------

HB_FUNC( APR_FILELOAD )
{
	const char *szFileName = hb_parc( 1 );
	apr_file_t *file;
	apr_pool_t *pool = getReqRecPtr()->pool;

	if( apr_file_open( &file, szFileName, APR_READ | APR_BINARY, APR_OS_DEFAULT, pool ) == APR_SUCCESS )
	{
		apr_finfo_t finfo;
		apr_size_t size;
		char *pBuffer;

		apr_file_info_get( &finfo, APR_FINFO_NORM, file );
		size = finfo.size;
		pBuffer = ( char * ) apr_pcalloc( pool, size );

		if( pBuffer && ( apr_file_read( file, pBuffer, &size ) == APR_SUCCESS ) )
		{
			hb_retclen( pBuffer, size );
		}
		else
		{
			hb_retc_null();
		}

		apr_file_close( file );
	}
	else
	{
		hb_retc_null();
	}
}

//-----------------------------------------------------------------------------------

HB_FUNC( APR_READCODE )
{
	request_rec *r = getReqRecPtr();
	apr_size_t size = r->finfo.size;

	if( size > 0 )
	{
		apr_file_t *file;

		if( apr_file_open( &file, r->filename, APR_READ | APR_BINARY, APR_OS_DEFAULT, r->pool ) == APR_SUCCESS )
		{
			char *pBuffer = ( char * ) apr_pcalloc( r->pool, size );

			if( pBuffer && apr_file_read( file, pBuffer, &size ) == APR_SUCCESS )
			{
				hb_retclen( pBuffer, size );
			}
			else
			{
				hb_retc_null();
			}

			apr_file_close( file );
		}
		else
		{
			hb_retc_null();
		}
	}
	else
	{
		hb_retc_null();
	}
}

//-----------------------------------------------------------------------------------
