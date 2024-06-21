procedure main()

	static n := 0
	local hFile
	local cFName := ap_getScriptPath() + "lolo1.log"
	
	apr_lock()
    hFile := if( hb_FileExists( cFName ), FOpen( cFName, 2 ), FCreate( cFName ) )
	
	FSeek( hFile, 0, 2 )
    FWrite( hFile, HB_NToS( ++n ) + hb_eol() )
    FClose( hFile )
	apr_unLock()

return

