#include "precomp.h"

extern "C" {
	typedef int (*PHB_APACHE)(void* pRequestRec, void* pAPRPuts,
		const char* szFileName, const char* szArgs, const char* szMethod, const char* szUserIP,
		void* pHeadersIn, void* pHeadersOut,
		void* pHeadersInCount, void* pHeadersInKey, void* pHeadersInVal,
		void* pPostPairsCount, void* pPostPairsKey, void* pPostPairsVal,
		void* pHeadersOutCount, void* pHeadersOutSet, void* pSetContentType,
		void* pApacheGetenv, void* pAPBody, long lAPRemaining);

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

	__declspec (dllexport) int ap_rputs(const char* szText, IHttpContext* pHttpContext)
	{
		HTTP_DATA_CHUNK dataChunk;
		IHttpResponse* pHttpResponse = pHttpContext->GetResponse();

		dataChunk.DataChunkType = HttpDataChunkFromMemory;
		dataChunk.FromMemory.pBuffer = (PVOID)szText;
		dataChunk.FromMemory.BufferLength = (ULONG)strlen(szText);

		return pHttpResponse->WriteEntityChunkByReference(&dataChunk, -1);
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

	void ap_headers_out_set(const char* szKey, const char* szValue)
	{
	}

	void ap_set_contenttype(const char* szContentType)
	{
	}

	const char* ap_getenv(const char* szVarName)
	{
		return "";
	}

	const char* ap_body(void)
	{
		return "";
	}

}

long lAPRemaining = 0;

REQUEST_NOTIFICATION_STATUS CMyHttpModule::OnAcquireRequestState( IN IHttpContext * pHttpContext,
																  IN OUT IHttpEventProvider * pProvider )
{
    HRESULT hr = S_OK;
	DWORD cbValue = 512;
	PCSTR pszPathInfo = (PCSTR) pHttpContext->AllocateRequestMemory( cbValue );

	pHttpContext->GetServerVariable( "PATH_INFO", &pszPathInfo, &cbValue );

	if( strstr( pszPathInfo, ".prg" ) )
	{
		IHttpResponse * pHttpResponse = pHttpContext->GetResponse();
		HMODULE lib_harbour = LoadLibrary( "c:\\Windows\\SysWOW64\\inetsrv\\libharbour.dll" );

		pHttpResponse->SetHeader( "Content-Type", "text/html", strlen( "text/html" ), true );

		if( lib_harbour == NULL )
		{
			char * szErrorMessage = GetErrorMessage( GetLastError() );

			ap_rputs( szErrorMessage, pHttpContext );
			LocalFree( ( void * ) szErrorMessage );
		}
		else
		{
			PHB_APACHE _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );
			int iResult = 0;
				
			if( _hb_apache != NULL )
			{
 				_hb_apache( pHttpContext, ap_rputs, "c:\\inetpub\\wwwroot\\hello.prg", "", "GET", "localhost",
							NULL, NULL,
							(void*) ap_headers_in_count, (void*) ap_headers_in_key, (void*) ap_headers_in_val,
							(void*) ap_post_pairs_count, (void*) ap_post_pairs_key, (void*) ap_post_pairs_val,
							(void*) ap_headers_out_count, (void*) ap_headers_out_set, (void*) ap_set_contenttype,
							(void*) ap_getenv, (void*) ap_body, lAPRemaining);
 			}
			
			if( _hb_apache != NULL )
			{
				ap_rputs( "<h1>mod_harbour for IIS - hb_apache() yes!!!</h1>", pHttpContext );
				ap_rputs( pszPathInfo, pHttpContext );
			}
			else
				ap_rputs( "can't find hb_apache()", pHttpContext );
		}

		if( lib_harbour )
			FreeLibrary( lib_harbour );
		
		return RQ_NOTIFICATION_FINISH_REQUEST;
	}
	else
       return RQ_NOTIFICATION_CONTINUE;
}