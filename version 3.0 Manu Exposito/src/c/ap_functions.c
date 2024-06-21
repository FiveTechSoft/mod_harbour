//-----------------------------------------------------------------------------------
// Mod_Habour v1.00
// Fuente: ap_functions
//-----------------------------------------------------------------------------------

#include "mod_harbour.h"

//-----------------------------------------------------------------------------------

static void _arrayHeaderToXHash( const apr_array_header_t *array );
static void _strToXHash( char *buffer, const char *sep );

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETHEADERSIN )
{
	_arrayHeaderToXHash( apr_table_elts( getReqRecPtr()->headers_in ) );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETHEADERSOUT )
{
	_arrayHeaderToXHash( apr_table_elts( getReqRecPtr()->headers_out ) );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_COOKIEWRITE )
{
	const char *szName = hb_parc( 1 );
	const char *szValue = hb_parc( 2 );

	if( szName && szValue )
	{
		request_rec *r = getReqRecPtr();

		hb_retl( ap_cookie_write( r, szName, szValue, DEFAULT_ATTRS,
								  hb_parnldef( 3, 0 ), r->headers_out,
								  r->err_headers_out, NULL ) == APR_SUCCESS );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

//-----------------------------------------------------------------------------------
// ap_cookie_read( request_rec * r, const char *name, const char **val, int remove )

HB_FUNC( AP_COOKIEREAD )     
{
	const char *szName = hb_parc( 1 );

	if( szName )
	{
		const char *val = NULL;

		ap_cookie_read( getReqRecPtr(), szName, &val, hb_parldef( 2, HB_FALSE ) );

		hb_retc( val );
	}
	else
	{
		hb_retc_null();
	}
}

//-----------------------------------------------------------------------------------
// ap_cookie_check_string( const char *string )

HB_FUNC( AP_COOKIECHECK )
{
	const char *szName = hb_parc( 1 );

	hb_retl( szName ? ap_cookie_check_string( szName ) == APR_SUCCESS : HB_FALSE );
}

//-----------------------------------------------------------------------------------
// ap_cookie_remove(request_rec *r, const char *name, const char *attrs, ...)

HB_FUNC( AP_COOKIEREMOVE )
{
	const char *szName = hb_parc( 1 );

	hb_retl( szName ? ( ap_cookie_remove( getReqRecPtr(), szName, DEFAULT_ATTRS, NULL ) == APR_SUCCESS ) : HB_FALSE );
}

//-----------------------------------------------------------------------------------
// Recupera todas las cookies

HB_FUNC( AP_COOKIEREADALL )
{
	request_rec *r = getReqRecPtr();

	_strToXHash( apr_pstrcat( r->pool, ";", apr_table_get( r->headers_in, "cookie" ), NULL ), ";" );
}

//-----------------------------------------------------------------------------------
// Escribe en el bufer de salida variables simples. Solo imprime el primer parametro.

HB_FUNC( AP_RWRITE )
{
	if( hb_pcount() )
	{
		HB_SIZE nLen;
		HB_BOOL bFreeReq;
		char *buffer = hb_itemString( hb_param( 1, HB_IT_ANY ), &nLen, &bFreeReq );

		ap_rwrite( buffer, ( int ) nLen, getReqRecPtr() );

		if( bFreeReq )
		{
			hb_xfree( buffer );
		}
	}
}

//-----------------------------------------------------------------------------------
// Sinonimo de AP_RWRITE

HB_FUNC( AP_RPUTS )
{
	HB_FUNC_EXEC( AP_RWRITE );
}

//-----------------------------------------------------------------------------------
// Escribe en el bufer variables simples y complejas.
// Imprime la lista de parametros completa.

HB_FUNC( AP_ECHO )
{
	request_rec *r = getReqRecPtr();
	int iParams = hb_pcount();
	int  i;
	PHB_ITEM pItem;
	HB_SIZE nLen;
	HB_BOOL bFreeReq;
	char *buffer;

	for( i = 1; i <= iParams; i++ )
	{
		pItem = hb_param( i, HB_IT_ANY );

		if( !( HB_ISHASH( i ) || HB_ISARRAY( i ) || HB_ISOBJECT( i ) ) )
		{
			buffer = hb_itemString( pItem, &nLen, &bFreeReq );

			ap_rwrite( buffer, ( int ) nLen, r );

			if( bFreeReq )
			{
				hb_xfree( buffer );
			}
		}
		else
		{
			hb_vmPushSymbol( hb_dynsymGetSymbol( "MH_VALTOSTR" ) );
			hb_vmPushNil();
			hb_vmPush( pItem );
			hb_vmFunction( 1 );

			ap_rwrite( hb_parc( -1 ), ( int ) hb_parclen( -1 ), r );
		}
	}
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_SETHEADEROUT )
{
	const char *szKey = hb_parc( 1 );

	if( szKey )
	{
		apr_table_add( getReqRecPtr()->headers_out, szKey, hb_parc( 2 ) );
	}
}

//-----------------------------------------------------------------------------------
// Obtiene variables de entorno de Apache

HB_FUNC( AP_GETENV )
{
	const char *szVar = hb_parc( 1 );

	if( szVar )
	{
		hb_retc( apr_table_get( getReqRecPtr()->subprocess_env, szVar ) );
	}
}

//-----------------------------------------------------------------------------------
// Obtiene solo variables de entorno del SO

HB_FUNC( AP_GETSYSENV )
{
	char *value = NULL;

	apr_env_get( &value, hb_parc( 1 ), getReqRecPtr()->pool );

	hb_retc( ( const char * ) value );
}

//-----------------------------------------------------------------------------------
// Envia variables de entorno al SO

HB_FUNC( AP_SETSYSENV )
{
	hb_retl( apr_env_set( hb_parc( 1 ), hb_parc( 2 ), getReqRecPtr()->pool ) == APR_SUCCESS );
}

//-----------------------------------------------------------------------------------
// Elimina variables de entorno al SO

HB_FUNC( AP_DELETESYSENV )
{
	hb_retl( apr_env_delete( hb_parc( 1 ), getReqRecPtr()->pool ) == APR_SUCCESS );
}

//===================================================================================
// Funciones interface de los miembros de la estructura request_rec
//===================================================================================
// Configura las variables estándar de CGI

HB_FUNC( AP_SETCGIVAR )
{
	request_rec *r = getReqRecPtr();

	ap_add_common_vars( r );
	ap_add_cgi_vars( r );
}

//-----------------------------------------------------------------------------------
// Devuelve el PATH de los programas PRG

HB_FUNC( AP_GETSCRIPTPATH )
{
	PHB_FNAME pFilepath = hb_fsFNameSplit( getReqRecPtr()->filename );

	hb_retc( pFilepath->szPath );
	hb_xfree( pFilepath );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_SETCONTENTTYPE )
{
	const char *ct = hb_parc( 1 );

	if( ct )
	{
		ap_set_content_type( getReqRecPtr(), ct );
	}
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETCONTENTTYPE )
{
	hb_retc( getReqRecPtr()->content_type );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETHOSTNAME )
{
	hb_retc( getReqRecPtr()->hostname );
}

//-----------------------------------------------------------------------------------
// Devuelve url con el programa PRG

HB_FUNC( AP_GETURI )
{
	hb_retc( getReqRecPtr()->uri );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETFILENAME )
{
	hb_retc( getReqRecPtr()->filename );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETMETHOD )
{
	hb_retc( getReqRecPtr()->method );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETUSERIP )
{
	hb_retc( getReqRecPtr()->useragent_ip );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETARGS )
{
	hb_retc( getReqRecPtr()->args );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETSTATUS )
{
	hb_retni( getReqRecPtr()->status );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_READPOST )
{
	request_rec *r = getReqRecPtr();
	char *wBuffer = NULL;

	if( ( ap_setup_client_block( r, REQUEST_CHUNKED_ERROR ) == OK ) && ap_should_client_block( r ) )
	{
		long length = ( long ) r->remaining + 1;
		int iRead, iTotal = 0;

		wBuffer = apr_pcalloc( r->pool, length );

		while( ( ( iRead = ap_get_client_block( r, wBuffer + iTotal, length - iTotal ) ) < ( length - iTotal ) ) && ( iRead > 0 ) )
		{
			iTotal += iRead;
		}
	}

	_strToXHash( wBuffer, "&" );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETBODY )
{
	HB_FUNC_EXEC( AP_READPOST );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_READGET )
{
	apr_table_t *GET = NULL;

	ap_args_to_table( getReqRecPtr(), &GET );

	_arrayHeaderToXHash( apr_table_elts( GET ) );
}

//-----------------------------------------------------------------------------------
// URL encode

HB_FUNC( AP_URLDECODE )
{
	const char *url = hb_parc( 1 );

	if( url )
	{
		ap_unescape_urlencoded( ( char * ) url );
	}

	hb_retc( url );
}

//-----------------------------------------------------------------------------------
// URL decode

HB_FUNC( AP_URLENCODE )
{
	const char *url = hb_parc( 1 );

	if( url )
	{
		hb_retc( ap_escape_urlencoded( getReqRecPtr()->pool, url ) );
	}
	else
	{
		hb_retc_null();
	}
}

//-----------------------------------------------------------------------------------
// HTML encode

HB_FUNC( AP_HTMLENCODE )
{
	const char *url = hb_parc( 1 );

	if( url )
	{
		hb_retc( ap_escape_html( getReqRecPtr()->pool, url ) );
	}
	else
	{
		hb_retc_null();
	}
}

//-----------------------------------------------------------------------------------
// Sinonimo de AP_HTMLENCODE

HB_FUNC( AP_ESCAPEHTML )
{
	HB_FUNC_EXEC( AP_HTMLENCODE );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_SETPERSISTENT )
{
	PHB_ITEM pKey = hb_param( 2, HB_IT_HASHKEY );
	PHB_ITEM pValue = hb_param( 3, HB_IT_ANY );

	if( pKey && pValue )
	{
		PHB_ITEM pNameSpace = hb_param( 1, HB_IT_HASHKEY );
		HB_BOOL bRelease = !pNameSpace;
		PHB_ITEM pWPers = hb_hashNew( NULL );

		if( bRelease )
		{
			pNameSpace = hb_itemPutCConst( NULL, "public" );
		}

		hb_hashAdd( pWPers, pKey, pValue );

		hb_hashAdd( pGD->hPersistent, pNameSpace, pWPers );
		hb_itemRelease( pWPers );
	}
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_GETPERSISTENT )
{
	PHB_ITEM pKey = hb_param( 2, HB_IT_HASHKEY );
	PHB_ITEM pRes = NULL;

	if( pKey )
	{
		PHB_ITEM pNameSpace = hb_param( 1, HB_IT_HASHKEY );
		HB_BOOL bRelease = !pNameSpace;
		PHB_ITEM pWPers;

		if( bRelease )
		{
			pNameSpace = hb_itemPutCConst( NULL, "public" );
		}

		if( ( pWPers = hb_hashGetItemPtr( pGD->hPersistent, pNameSpace, HB_HASH_AUTOADD_ACCESS ) ) != NULL )
		{
			pRes = hb_hashGetItemPtr( pWPers, pKey, HB_HASH_AUTOADD_ACCESS );
		}

		if( bRelease )
		{
			hb_itemRelease( pNameSpace );
		}
	}

	hb_itemReturn( pRes ? pRes : hb_param( 3, HB_IT_ANY ) );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_STRFROMPTR )
{
	const char **pStrs = ( const char ** ) hb_parptr( 1 );
	long lPos = hb_parnldef( 1, 1 ) - 1;

	hb_retc( *( pStrs + lPos ) );
}

//-----------------------------------------------------------------------------------

HB_FUNC( AP_INTFROMPTR )
{
	unsigned int *pNums = ( unsigned int * ) hb_parptr( 1 );
	long lPos = hb_parnldef( 1, 1 ) - 1;

	hb_retnl( *( pNums + lPos ) );
}

//===================================================================================
// Funciones estaticas de uso solo en es modulo
//===================================================================================

//-----------------------------------------------------------------------------------
// Pasa un array_header a un hash de Harbour. (De uso interno de este modulo.)
// El hash lo pone en el return de la pila de Harbour

static void _arrayHeaderToXHash( const apr_array_header_t *array )
{
	PHB_ITEM hHeaders = hb_hashNew( NULL );

	if( !apr_is_empty_array( array ) )
	{
		int iKey;
		PHB_ITEM pKey = hb_itemNew( NULL );
		PHB_ITEM pValue = hb_itemNew( NULL );
		apr_table_entry_t *table = ( apr_table_entry_t * ) array->elts;

		hb_hashPreallocate( hHeaders, array->nelts );

		for( iKey = 0; iKey < array->nelts; iKey++ )
		{
			hb_itemPutCConst( pKey, table[ iKey ].key );
			hb_itemPutCConst( pValue, table[ iKey ].val );
			hb_hashAdd( hHeaders, pKey, pValue );
		}

		hb_itemRelease( pKey );
		hb_itemRelease( pValue );
	}

	hb_itemReturnRelease( hHeaders );
}

//-----------------------------------------------------------------------------------
// Crea un hash de Harbour a partir de una cadena que tiene un separador por
// pares con (sep)key1=value1(Sep)key2=value2...(Sep)keyn=valuen
// El hash lo pone en el return de la pila de Harbour

static void _strToXHash( char *buffer, const char *sep )
{
	PHB_ITEM xHash = hb_hashNew( NULL );

	if( buffer && sep )
	{
		PHB_ITEM pKey = hb_itemNew( NULL );
		PHB_ITEM pValue = hb_itemNew( NULL );
		char *key, *value, *state;

		key = apr_strtok( buffer, sep, &state );

		while( key )
		{
			value = strchr( key, '=' );

			if( value )
			{
				*value++ = '\0';
			}
			else
			{
				value = "";
			}

			ap_unescape_urlencoded( key );
			hb_itemPutCConst( pKey, key );
			ap_unescape_urlencoded( value );
			hb_itemPutCConst( pValue, value );
			hb_hashAdd( xHash, pKey, pValue );

			key = apr_strtok( NULL, sep, &state );
		}

		hb_itemRelease( pKey );
		hb_itemRelease( pValue );
	}

	hb_itemReturnRelease( xHash );
}

//-----------------------------------------------------------------------------------
