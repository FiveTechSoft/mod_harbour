//-------------------------------------------------------------------------------------//

/*
   sessions.prg - Sessions Engine for mod_harbour
   (c) 2020 Lorenzo De Linares Álvarez - lorenzo.linares@icloud.com
   Released under MIT Licence. Please use it giving credit to the author of the code.

   This module implements sessions on mod_harbour. Sessions are used to save
   data on a session hash table. The saved data on the server is encrypted by
   a key that it is only stored on the client and is unique for each session.
*/

//-------------------------------------------------------------------------------------//

#include "/home/lorenzo/harbour/include/fileio.ch"

function SessionStart() // Starts a session
    /*
       Creates the .hb_sessions directory on the temp dir if not already created, creates the session hash table and saves the session id on a cookie.
    */ 
    local cChars := "0123456789ABCDEF"
    local cUUID  := ""
    local cPass  := ""
    local cCookie := GetCookieByKey( "_HB_SESSION_" )
    local hStart := { => }
    local cKey, cDataDesenc, cDataEnc
    local cReturned := .F.
    local nHandle
    
    if cCookie == nil
       for n = 1 to 16
          cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
          cPass += SubStr( cChars, hb_Random( 1, 16 ), 1 )
       next

       if ! hb_DirExists( hb_DirTemp() + ".hb_sessions" )
          hb_DirCreate( hb_DirTemp() + ".hb_sessions" )
       endif
       
       cKey := hb_blowfishKey( cPass )
    
       cDataDesenc = hb_Serialize( hStart )
       cDataEnc = hb_blowfishEncrypt( cKey, cDataDesenc )

       if ( nHandle := FCreate( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses" ) ) > 0
          hb_MemoWrit( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses", cDataEnc )
          FClose( nHandle )
       else
          cReturned = .F.
       endif
    
       cCookie = cUUID + ":" + cPass
    
       SetCookie( "_HB_SESSION_", cCookie )
       cReturned = .T.
    endif
 
 return cReturned
 
 //-------------------------------------------------------------------------------------//
 
 function GetSession() // Gets the session hash table
    /*
       Returns the session hash table of the session id on the cookie. If session has not been started returns nil.
    */
    local cCookie := GetCookieByKey( "_HB_SESSION_" )
    local cUUID, cPass, cKey
    local cDataEnc, cDataDesenc, hReturned
    
    if cCookie != nil
       cUUID := Left( cCookie, 16 )
       cPass := Right( cCookie, 16 )
       cKey := hb_blowfishKey( cPass )

       if File( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses" )
          cDataEnc := hb_MemoRead( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses" )
          if ! Empty( cDataEnc )
            cDataDesenc := hb_blowfishDecrypt( cKey, cDataEnc )
            hReturned := hb_Deserialize( cDataDesenc )
          else
            hReturned = {=>}
          endif
       else
          SetCookie( "_HB_SESSION_", "", 0 )
          hReturned = nil
       endif

    else
       hReturned = nil
    endif
 
 return hReturned
 
 //-------------------------------------------------------------------------------------//
 
 function GetSessionByKey( cKey ) // Gets the value of a key on the session hash table
    /*
       Returns the value of the key sent on the parameter. If it does not exists or session has not been started returns nil.
    */
    local hSession := GetSession()
    local cReturned := nil
    
    if hSession != nil .and. ! Empty( hSession )
       if hb_HHasKey( hSession, cKey )
          cReturned = hSession[ cKey ]
       endif
    endif
 
 return cReturned
 
 //-------------------------------------------------------------------------------------//
 
 function SetSessionByKey( cKey, cData ) // Sets the value of a key on the session hash table
    /*
       Sets the value of the key sent on the parameter to the sent data. Returns true if it has been added correctly, false in other case.
    */
    local hSession := GetSession()
    local cReturned := .F.
    
    if hSession != nil
      hb_HSet( hSession, cKey, cData )
      SaveSession( hSession )
      cReturned = .T.
    endif
 
 return cReturned
 
 //-------------------------------------------------------------------------------------//
 
 function SaveSession( cHash ) // Replaces the session hash table to the sent hash table
    /*
       Sets the hash table of the session to the hash table sent on the parameter. Returns true if replaced correctly, false in other case.
    */
    local cCookie := GetCookieByKey( "_HB_SESSION_" )
    local cUUID, cPass, cKey
    local cDataEnc, cDataDesenc, cReturned
    
    if cCookie != nil
       cUUID := Left( cCookie, 16 )
       cPass := Right( cCookie, 16 )
       cKey := hb_blowfishKey( cPass )
    
       cDataDesenc = hb_Serialize( cHash )
       cDataEnc = hb_blowfishEncrypt( cKey, cDataDesenc )

       if File( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses" )
          cReturned := hb_MemoWrit( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses", cDataEnc )
       else
          SetCookie( "_HB_SESSION_", "", 0 )
          cReturned = .F.
       endif
    else
       cReturned = .F.
    endif
 
 return cReturned
 
 //-------------------------------------------------------------------------------------//
 
 function SessionDestroy() // Deletes and destroy the session.
    /*
       Deletes the file of the session and removes the session cookie.
    */
    local cCookie := GetCookieByKey( "_HB_SESSION_" )
    local cUUID, cReturned
    
    if cCookie != nil
       cUUID := Left( cCookie, 16 )
       cReturned := hb_FileDelete( hb_DirTemp() + ".hb_sessions/" + cUUID + ".ses" )
       SetCookie( "_HB_SESSION_", "", 0 )
    else
       cReturned = .F.
    endif
 return cReturned
 
 //-------------------------------------------------------------------------------------//
 
 function GetCookieByKey( cKey ) // SUPPORT FUNCTION. Gets a cookie by key
    local hCookies := GetCookies()
    local cResponse
    
    if hb_HHasKey( hCookies, cKey )
       cResponse = hCookies[ cKey ]
    else
       cResponse = nil
    endif
    
 return cResponse
 
 //-------------------------------------------------------------------------------------//
