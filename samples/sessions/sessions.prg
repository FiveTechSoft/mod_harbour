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

function SessionStart() // Starts a session
   /*
      Creates the hb_sessions.dbf on the temp dir if not already created, creates the session hash table and saves the session id on a cookie.
   */ 
   local cChars := "0123456789ABCDEF"
   local cUUID  := ""
   local cPass  := ""
   local cCookie := GetCookieByKey( "_HB_SESSION_" )
   local hStart := { => }
   local cKey, cDataDesenc, cDataEnc
   local cReturned := .F.
   
   if cCookie == nil
      for n = 1 to 16
         cUUID += SubStr( cChars, hb_Random( 1, 16 ), 1 )
         cPass += SubStr( cChars, hb_Random( 1, 16 ), 1 )
      next
   
      if ! File( hb_DirTemp() + "/hb_sessions.dbf" )
         DbCreate( hb_DirTemp() + "/hb_sessions.dbf",;
                   { { "SESSIONID",   "C", 16, 0 },;
                     { "DATA",        "M", 1000, 0 } } )
      endif
      
      cKey := hb_blowfishKey( cPass )
   
      cDataDesenc = hb_Serialize( hStart )
      cDataEnc = hb_blowfishEncrypt( cKey, cDataDesenc )
   
      USE ( hb_DirTemp() + "/hb_sessions" )
      APPEND BLANK
      if RLock()
         Field->SessionId   := cUUID
         Field->Data := cDataEnc
         DbUnLock()
      endif  
   
      USE
   
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
      
      USE ( hb_DirTemp() + "/hb_sessions" )
      SET FILTER TO Field->SessionId = cUUID
   
      dbSetFilter( {|| Field->SessionId = cUUID } )
      dbGoTop()
      cDataEnc = Field->Data
      if !Empty(cDataEnc)
         cDataDesenc = hb_blowfishDecrypt( cKey, cDataEnc )
         hReturned = hb_Deserialize( cDataDesenc )
      else
         hReturned = cDataEnc
      endif
   
      USE
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

      USE ( hb_DirTemp() + "/hb_sessions" )
      SET FILTER TO Field->SessionId = cUUID
   
      dbSetFilter( {|| Field->SessionId = cUUID } )
      dbGoTop()
      if RLock()
         Field->Data := cDataEnc
         DbUnLock()
      endif
   
      USE
      cReturned = .T.
   else
      cReturned = .F.
   endif

return cReturned

//-------------------------------------------------------------------------------------//

function SessionDestroy() // Deletes and destroy the session.
   /*
      Deletes the record of the session on the DBF and removes the session cookie.
   */
   local cCookie := GetCookieByKey( "_HB_SESSION_" )
   local cUUID, cReturned
   
   if cCookie != nil
      cUUID := Left( cCookie, 16 )

      USE ( hb_DirTemp() + "/hb_sessions" )
      SET FILTER TO Field->SessionId = cUUID
   
      dbSetFilter( {|| Field->SessionId = cUUID } )
      dbGoTop()
      if RLock()
         DELETE
         PACK
         DbUnLock()
      endif 
      
      USE
      SetCookie( "_HB_SESSION_", "", 0 )
      cReturned = .T.
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

function Debug_RetrieveAllSessions() // DEBUG FUNCTION. Prints the sessions DBF as it is.
   USE ( hb_DirTemp() + "/hb_sessions" )
   while ! EOF()
      ? Field->SessionId
      ? Field->Data
      SKIP
   end
   
   USE

return nil

//-------------------------------------------------------------------------------------//