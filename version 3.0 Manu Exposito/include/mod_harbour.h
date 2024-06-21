//-----------------------------------------------------------------------------------
// Mod_Harbour include
//-----------------------------------------------------------------------------------

#ifndef MOD_HARBOUR_H_
#define MOD_HARBOUR_H_

//-----------------------------------------------------------------------------------

/* Includes de Apache */
#include "httpd.h"
#include "http_config.h"
#include "http_protocol.h"
#include "util_script.h"
#include "apr.h"
#include "apr_hash.h"
#include "apr_strings.h"
#include "apr_env.h"
#include "util_cookies.h"

/* Includes de Harbour */
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbapierr.h"
#include "hbthread.h"
#include "hbxvm.h"

//-----------------------------------------------------------------------------------
// Estructura de datos globales

typedef struct
{
    apr_hash_t *mhb_request;
    apr_thread_mutex_t *lock;
    PHB_ITEM hPersistent;
} MHBGLOBALDATA, *PMHBGLOBALDATA;

//-----------------------------------------------------------------------------------
// Declaracion de variables globales

extern PMHBGLOBALDATA pGD;
module AP_MODULE_DECLARE_DATA harbour_module;

//-----------------------------------------------------------------------------------
// Seudofunciones para usar en C

#define _MH_LOCK( m )		apr_thread_mutex_lock( ( m ) )
#define _MH_TRYLOCK( m )	apr_thread_mutex_trylock( ( m ) )
#define _MH_UNLOCK( m )		apr_thread_mutex_unlock( ( m ) )
#define _MH_DESTROY( m )	apr_thread_mutex_destroy( ( m ) )

//-----------------------------------------------------------------------------------
// Funciones de uso en C

request_rec *getReqRecPtr( void );

//-----------------------------------------------------------------------------------

#endif /* fin de MOD_HARBOUR_H_ */

//-----------------------------------------------------------------------------------