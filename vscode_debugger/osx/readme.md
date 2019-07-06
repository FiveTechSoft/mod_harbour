```
			hb_inetSend( t_oDebugInfo['socket'],;
				"/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock" + CRLF + ;
				Str( PID( "/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock" ) ) + CRLF )
```

```
#define LINE_LENGTH 200

HB_FUNC( PID )
{
   char line[ LINE_LENGTH ];
   FILE * command = popen( hb_parc( 1 ), "r" );

   fgets( line, LINE_LENGTH, command );

   hb_retnll( ( HB_LONGLONG ) strtoul( line, NULL, 10 ) );
   pclose( command );   
} 
```
