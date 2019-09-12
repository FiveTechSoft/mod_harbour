#include "precomp.h"

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
		HTTP_DATA_CHUNK dataChunk;

		pHttpResponse->SetHeader( "Content-Type", "text/html", strlen("text/html"), true );

		dataChunk.DataChunkType = HttpDataChunkFromMemory;
		dataChunk.FromMemory.pBuffer = (PVOID) "<h1>mod_harbour for IIS</h1>";
		dataChunk.FromMemory.BufferLength = (ULONG) strlen("<h1>mod_harbour for IIS</h1>" );

		pHttpResponse->WriteEntityChunkByReference( &dataChunk, -1 );
		
		return RQ_NOTIFICATION_FINISH_REQUEST;
	}
	else
       return RQ_NOTIFICATION_CONTINUE;
}