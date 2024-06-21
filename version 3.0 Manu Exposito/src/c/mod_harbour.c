//-----------------------------------------------------------------------------------
// Mod_Habour v1.00
// Fuente: mod_harbour.c
//-----------------------------------------------------------------------------------

#include "mod_harbour.h"

//-----------------------------------------------------------------------------------
// Puntero a la estructura de datos globales
PMHBGLOBALDATA pGD;

// Funciones externas
HB_FUNC( MH_RUN );
HB_FUNC( MH_RUN_HRB );

HB_EXTERN_C_ HB_EXPORT HARBOUR( *PFUNC_RUN )( void );

//-----------------------------------------------------------------------------------
// Devuelve el request_rec asociado al hilo de ejecucion actual

request_rec *getReqRecPtr( void )
{
	apr_os_thread_t pId = apr_os_thread_current();

	return apr_hash_get( pGD->mhb_request, &pId, sizeof( apr_os_thread_t ) );
}

//-----------------------------------------------------------------------------------
// Funcion de salida. Libera los miembros de la estructura global data y la MV

static apr_status_t harbour_child_shutdown( void *data )
{
	HB_SYMBOL_UNUSED( data );

	// Limpia la tabla hash
	apr_hash_clear( pGD->mhb_request );

	// Destruye el mutex general
	apr_thread_mutex_destroy( pGD->lock );

	// Destruye el item de persistencia
	if( pGD->hPersistent )
	{
		hb_itemRelease( pGD->hPersistent );
		 pGD->hPersistent = NULL;
	}

	// Libera la VM
	if( hb_vmIsActive() )
	{
		hb_vmQuit();
	}

	return APR_SUCCESS;
}

//-----------------------------------------------------------------------------------
// Funcion ap_hook que solo se inicia una vez.
// Notas: Aqui pondremos todo lo que se tiene que propagar a todas las peticiones
// del modulo.

static int harbour_child_init( apr_pool_t *pool, server_rec *s )
{
	HB_SYMBOL_UNUSED( s );

	pGD = apr_pcalloc( pool, sizeof( MHBGLOBALDATA ) );

	// Estructura global con hash para el request.
	pGD->mhb_request = apr_hash_make( pool );

	// Crea del mutex por defecto
	apr_thread_mutex_create( &pGD->lock, APR_THREAD_MUTEX_DEFAULT, pool );

	hb_vmInit( HB_FALSE );

	// Control de persistencia a nivel de servidor
	pGD->hPersistent = hb_hashNew( NULL );

	// Desactiva CASE MATCH
	if( ( hb_hashGetFlags( pGD->hPersistent ) & HB_HASH_IGNORECASE ) == 0 )
	{
		hb_hashClearFlags( pGD->hPersistent, HB_HASH_BINARY );
		hb_hashSetFlags( pGD->hPersistent, HB_HASH_IGNORECASE | HB_HASH_RESORT );
	}

	//Funcion de salida
	apr_pool_cleanup_register( pool, NULL, harbour_child_shutdown, apr_pool_cleanup_null );

	return OK;
}

//-----------------------------------------------------------------------------------
// Manejador principal del modulo.
// Se ejecuta por cada peticion.

static int harbour_handler( request_rec *r )
{
	if( strcmp( r->handler, "harbour" ) == 0 ) // Poner uno para los prg cacheados
	{
		PFUNC_RUN = HB_FUNCNAME( MH_RUN );
	}
	else if( strcmp( r->handler, "harbour_hrb" ) == 0 )
	{
		PFUNC_RUN = HB_FUNCNAME( MH_RUN_HRB );
	}
	else
	{
		return DECLINED;
	}

	// Asigna el request_rec del actual hilo de ejecucion al hash
	apr_os_thread_t pId = apr_os_thread_current();
	apr_hash_set( pGD->mhb_request, &pId, sizeof( apr_os_thread_t ), r );

	ap_set_content_type( r, "text/html" );

	// Iniciando la VM preparada para hilos
	hb_vmThreadInit( NULL );
	PFUNC_RUN(); // Llama al interprete de Harbour
	hb_vmThreadQuit();

	return OK;
}

//-----------------------------------------------------------------------------------
// Registro de funciones hooks

static void harbour_register_hooks( apr_pool_t *pool )
{
	HB_SYMBOL_UNUSED( pool );

	ap_hook_child_init( harbour_child_init, NULL, NULL, APR_HOOK_MIDDLE );
	ap_hook_handler( harbour_handler, NULL, NULL, APR_HOOK_MIDDLE );
}

//-----------------------------------------------------------------------------------
// Estructura de datos del modulo

module AP_MODULE_DECLARE_DATA harbour_module =
{
	STANDARD20_MODULE_STUFF,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	harbour_register_hooks
};

//-----------------------------------------------------------------------------------
