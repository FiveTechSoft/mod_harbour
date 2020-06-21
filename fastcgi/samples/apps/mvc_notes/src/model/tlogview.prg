#define FILELOG   AP_GETENV( 'DOCUMENT_ROOT' ) + AP_GETENV( 'PATH_APP' ) + '/data/logview.txt'

FUNCTION SetLogView()
	
	? FILELOG
	
RETU NIL