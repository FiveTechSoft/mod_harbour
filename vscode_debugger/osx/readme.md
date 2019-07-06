This is working fine too:
```
hb_inetSend( t_oDebugInfo['socket'],;
	     "/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock" + CRLF + "0" + CRLF )
				
```
```
 hb_inetSend( t_oDebugInfo['socket'],;
	      "/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock" + CRLF + ;
Str( PID( "Str( PID( "ps -A | grep -m1 /System/Library/CoreServices/Dock.app/Contents/MacOS/Dock | awk '{print $1}'" ) )" ) ) + CRLF )
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

launch.json
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "harbour-dbg",
            "request": "attach",
            "name": "Attach Program",
            "program": "/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock",
            "workingDir": "/",
            "sourcePaths": ["${workspaceFolder}"]
        }
    ]
}
```
