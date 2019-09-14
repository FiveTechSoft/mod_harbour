#include "precomp.h"

extern "C" {
	typedef int (*PHB_APACHE)(void* pRequestRec, void* pAPRPuts,
		const char* szFileName, const char* szArgs, const char* szMethod, const char* szUserIP,
		void* pHeadersIn, void* pHeadersOut,
		void* pHeadersInCount, void* pHeadersInKey, void* pHeadersInVal,
		void* pPostPairsCount, void* pPostPairsKey, void* pPostPairsVal,
		void* pHeadersOutCount, void* pHeadersOutSet, void* pSetContentType,
		void* pApacheGetenv, void* pAPBody, long lAPRemaining);

	static IHttpContext * _pHttpContext = NULL;

	char* GetErrorMessage(DWORD dwLastError)
	{
		LPVOID lpMsgBuf;

		FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
			NULL,
			dwLastError,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
			(LPTSTR)& lpMsgBuf,
			0,
			NULL);

		return ((char*)lpMsgBuf);
		LocalFree(lpMsgBuf);
	}

	int ap_rputs( const char * szText, IHttpContext * pHttpContext )
	{
		HTTP_DATA_CHUNK dataChunk;
		PCSTR pszText = ( PCSTR ) pHttpContext->AllocateRequestMemory( strlen( szText ) + 1 );
		IHttpResponse* pHttpResponse = pHttpContext->GetResponse();

		strcpy(( char * ) pszText, szText);

		dataChunk.DataChunkType = HttpDataChunkFromMemory;
		dataChunk.FromMemory.pBuffer = (PVOID) pszText;
		dataChunk.FromMemory.BufferLength = (ULONG) strlen( pszText );

		return pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 );
	}


	int ap_headers_out_count(void)
	{
		return 0;
	}

	const char* ap_headers_in_key(int iKey)
	{
		return "";
	}

	const char* ap_headers_in_val(int iKey)
	{
		return "";
	}

	int ap_post_pairs_count(void)
	{
		return 0;
	}

	const char* ap_post_pairs_key(int iKey)
	{
		return "";
	}

	const char* ap_post_pairs_val(int iKey)
	{
		return "";
	}

	int ap_headers_in_count(void)
	{
		return 0;
	}

	void ap_headers_out_set( const char * szKey, const char * szValue )
	{
	}

	void ap_set_contenttype( const char * szContentType )
	{
		IHttpResponse * pHttpResponse = _pHttpContext->GetResponse();

		pHttpResponse->SetHeader( "Content-Type", szContentType, strlen( szContentType ), true );
	}

	const char * ap_getenv( const char * szVarName )
	{
		PCSTR rawBuffer = NULL;
		DWORD rawLength = 0;

		_pHttpContext->GetServerVariable( szVarName, &rawBuffer, &rawLength );

		return rawBuffer;
	}

	const char * ap_args( void )
	{
		const char * at = strstr( ap_getenv( "HTTP_URL" ), "?" );

		return at ? at + 1 : "";
	}

	const char * ap_body( void )
	{
		return ap_getenv( "ALL_RAW" );
	}

	void byteToHexChar( PSTR pszBuffer, BYTE bValue )
	{
		pszBuffer[0] = 48 + (bValue >> 4) + ((bValue >> 4) > 9 ? 7 : 0);
		pszBuffer[1] = 48 + (bValue & 0xF) + ((bValue & 0xF) > 9 ? 7 : 0);
		return;
	}
}

static long lAPRemaining = 0;

REQUEST_NOTIFICATION_STATUS CMyHttpModule::OnAcquireRequestState( IN IHttpContext * pHttpContext,
																  IN OUT IHttpEventProvider * pProvider )
{
	const char * szPathInfo;

	_pHttpContext = pHttpContext;
	szPathInfo = ap_getenv( "PATH_INFO" );

	if( strstr( szPathInfo, ".prg" ) || strstr( szPathInfo, ".hrb" ) )
	{
		HMODULE lib_harbour = LoadLibrary( "c:\\Windows\\SysWOW64\\inetsrv\\libharbour.dll" );

		ap_set_contenttype( "text/html" );

		if( lib_harbour == NULL )
		{
			char * szErrorMessage = GetErrorMessage( GetLastError() );
			ap_rputs( szErrorMessage, pHttpContext );
			LocalFree( ( void * ) szErrorMessage );
		}
		else
		{
			PHB_APACHE _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );
			char szIP[] = "??.??.??.??";
			PSOCKADDR_IN pSockAddr_in = ( PSOCKADDR_IN ) pHttpContext->GetRequest()->GetRemoteAddress();
			char szPath[ 512 ];

			strcpy( szPath, "c:\\inetpub\\wwwroot" );
			strcat( szPath, szPathInfo );

			byteToHexChar( szIP + 0, pSockAddr_in->sin_addr.S_un.S_un_b.s_b1 );
			byteToHexChar( szIP + 3, pSockAddr_in->sin_addr.S_un.S_un_b.s_b2 );
			byteToHexChar( szIP + 6, pSockAddr_in->sin_addr.S_un.S_un_b.s_b3 );
			byteToHexChar( szIP + 9, pSockAddr_in->sin_addr.S_un.S_un_b.s_b4 );

			if( _hb_apache != NULL )
			{
 				_hb_apache( pHttpContext, ap_rputs, szPath, ap_args(), 
					        pHttpContext->GetRequest()->GetHttpMethod(), szIP,
							NULL, NULL,
							( void * ) ap_headers_in_count, ( void * ) ap_headers_in_key, ( void * ) ap_headers_in_val,
							( void * ) ap_post_pairs_count, ( void * ) ap_post_pairs_key, ( void * ) ap_post_pairs_val,
							( void * ) ap_headers_out_count, ( void * ) ap_headers_out_set, ( void * ) ap_set_contenttype,
							( void * ) ap_getenv, ( void * ) ap_body, lAPRemaining );
 			}
			
			if( _hb_apache == NULL )
				ap_rputs( "can't find hb_apache()", pHttpContext );
		}

		if( lib_harbour )
			FreeLibrary( lib_harbour );
		
		return RQ_NOTIFICATION_FINISH_REQUEST;
	}
	else
       return RQ_NOTIFICATION_CONTINUE;
}