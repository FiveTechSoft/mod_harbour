
#define HB_GTI_ISGRAPHIC        0   // 1 if GT has graphic support / pixel oriented 
#define HB_GTI_SCREENWIDTH      1   // Get/set width of application window in pixels 
#define HB_GTI_SCREENHEIGHT     2   // Get/set height of application window in pixels 
#define HB_GTI_SCREENDEPTH      3   // Amount of bits used for colors in the application 
#define HB_GTI_FONTSIZE         4   // Get/set height of application font in pixels 
#define HB_GTI_FONTWIDTH        5   // Get/set width of application font characters 
#define HB_GTI_DESKTOPWIDTH     6   // Get width of desktop in pixels 
#define HB_GTI_DESKTOPHEIGHT    7   // Get height of desktop in pixels 
#define HB_GTI_DESKTOPDEPTH     8   // Amount of bits used for colors in system 
#define HB_GTI_COMPATBUFFER     9   // Use DOS CGA/EGA/VGA character/attribute buffer in SAVE/REST SCREEN 
#define HB_GTI_KBDSHIFTS        10  // Keyboard shift/ctrl/alt, caps/num/scroll/windows keys' state 
#define HB_GTI_KBDSPECIAL       11  // This will get/set the status of the top row shift state handling. Enable to correct a documented keyboard handling bug under Win9x. Default is disabled. 
#define HB_GTI_KBDALT           12  // This will get/set the status of the Alt-NumPad key handling. Default is Enabled. 
#define HB_GTI_ISSCREENPOS      13  // Is full screen cursor positioning supported by GT driver? 
#define HB_GTI_KBDSUPPORT       14  // Is it keyboard input supported? 
#define HB_GTI_CLIPBOARDDATA    15  // Get/Set clipboard 
#define HB_GTI_CLIPBOARDPASTE   16  // Paste clipboard data into keyboard buffer 
#define HB_GTI_CURSORBLINKRATE  19  // Get/Set cursor blinking rate in milliseconds 
#define HB_GTI_DESKTOPROWS      20  // Get Size of desktop in character rows 
#define HB_GTI_DESKTOPCOLS      21  // Get Size of desktop in character cols 
#define HB_GTI_FONTWEIGHT       22  // Get/set the weight of the font used in application 
#define HB_GTI_FONTQUALITY      23  // Get/set quality of font rendering in the application 
#define HB_GTI_FONTNAME         24  // Set-only font name 
#define HB_GTI_CODEPAGE         25  // codepage 
#define HB_GTI_WINTITLE         26  // title 
#define HB_GTI_ICONFILE         27  // icon file 
#define HB_GTI_ICONRES          28  // icon resource 
#define HB_GTI_MOUSESTATUS      29  // mouse enabled = 1 mouse disabled = 0 
#define HB_GTI_INPUTFD          30  // Get Standard input stream of application/GT 
#define HB_GTI_OUTPUTFD         31  // Get Standard output stream of application/GT 
#define HB_GTI_ERRORFD          32  // Get Standard error stream of application/GT 
#define HB_GTI_ESCDELAY         33  // Get/Set escape key delay 
#define HB_GTI_VIEWMAXHEIGHT    34  // Maximum viewable height: for current mode 
#define HB_GTI_VIEWMAXWIDTH     35  // Maximum viewable width: either window or full screen 
#define HB_GTI_VIEWPORTHEIGHT   36  // Current viewport height: for current mode 
#define HB_GTI_VIEWPORTWIDTH    37  // Current viewport width: either window or full screen 
#define HB_GTI_STDOUTCON        38  // redirect STDOUT to console 
#define HB_GTI_STDERRCON        39  // redirect STDERR to console 
#define HB_GTI_ISCTWIN          40  // is CTWIN supported? 
#define HB_GTI_ISMULTIWIN       41  // is multi window supported? 
#define HB_GTI_GETWIN           42  // get current window handle or screen settings 
#define HB_GTI_SETWIN           43  // restore window or screen settings 
#define HB_GTI_NEWWIN           44  // create new window 
#define HB_GTI_ADDKEYMAP        45  // add key escape sequences 
#define HB_GTI_DELKEYMAP        46  // del key escape sequences 
#define HB_GTI_ISUNICODE        47  // is Unicode input/output enabled? 
#define HB_GTI_SELECTCOPY       48  // toggles screen content selection and copy to clipboard (supported by: GTWVT) 
#define HB_GTI_RESIZABLE        49  // toggles ability to resize window (supported by: GTWVT) 
#define HB_GTI_CLOSABLE         50  // toggles ability to close window (supported by: GTWVT) 
#define HB_GTI_NOTIFIERBLOCK    51  // Deprecated. Use HB_K_* inkey.ch events instead. 
#define HB_GTI_SCREENSIZE       52  // Get/Set height/width of application window in pixels 
#define HB_GTI_PALETTE          53  // Get/Set console colors 0 - 15 given an array of 16 elements containing RGB colors 
#define HB_GTI_RESIZEMODE       54  // Get/Set console resize mode : HB_GTI_RESIZEMODE_FONT | HB_GTI_RESIZEMODE_ROWS 
#define HB_GTI_SETPOS_XY        55  // Get/Set current top-left position coordinates of the window by pixels 
#define HB_GTI_SETPOS_ROWCOL    56  // Set current top-left position coordinates of the window by row/cols 
#define HB_GTI_BOXCP            57  // Codepage used for box drawing 
#define HB_GTI_CARGO            58  // Storage of any user defined value 
#define HB_GTI_FONTSEL          59  // X11 style font selecting 
#define HB_GTI_INKEYFILTER      60  // Get/Set inkey keycodes filter 
#define HB_GTI_INKEYREAD        61  // Get/Set inkey read block 
#define HB_GTI_ALTENTER         62  // Toggles Alt+Enter as full screen switch (supported by: GTWVT) 
#define HB_GTI_ISFULLSCREEN     63  // Is the GT windows using the full physical display? (supported by: GTWIN, GTWVT) 
#define HB_GTI_ONLINE           64  // Is terminal connected? 
#define HB_GTI_VERSION          65  // Get terminal version string 
#define HB_GTI_MAXIMIZED        66  // Get/Set Window's Maximized status (supported by: GTWVT) 
#define HB_GTI_FONTATTRIBUTE    67  // Get/Set font attribute 
#define HB_GTI_UNITRANS         68  // Set translation table for UNICODE characters 
#define HB_GTI_WINHANDLE        69  // Get console window low-level handle 
#define HB_GTI_MOUSEPOS_XY      70  // Get mouse position in pixels 
#define HB_GTI_DISPIMAGE        71  // Display image with given name 
#define HB_GTI_REDRAWMAX        72  // Maximum number of unchanged neighboring chars in redrawn line 
#define HB_GTI_RESIZESTEP       73  // Enable/Disable window resizing steps 
#define HB_GTI_CLOSEMODE        74  // Close event: 0 terminate application, >=1 generate HB_K_CLOSE, 2 disable close button 
#define HB_GTI_MINIMIZED        75  // Get/Set Window's Minimized status (supported by: GTQTC, GTXWC) 
#define HB_GTI_QUICKEDIT        76  // Enable/Disable quick edit mode (supported by: GTWVT) 
#define HB_GTI_SYSMENUADD       77  // Add item to window system menu with keycode to generate when selected (supported by: GTWVT) 

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

function Info()

   local cI    := ' '
   local n     := 0
   local x     := 0
   local aDefs := { ;
      { '0 ', ' HB_GTI_ISGRAPHIC       ' }, ; 
      { '1 ', ' HB_GTI_SCREENWIDTH     ' }, ;
      { '2 ', ' HB_GTI_SCREENHEIGHT    ' }, ;
      { '3 ', ' HB_GTI_SCREENDEPTH     ' }, ;
      { '4 ', ' HB_GTI_FONTSIZE        ' }, ;
      { '5 ', ' HB_GTI_FONTWIDTH       ' }, ;
      { '6 ', ' HB_GTI_DESKTOPWIDTH    ' }, ;
      { '7 ', ' HB_GTI_DESKTOPHEIGHT   ' }, ;
      { '8 ', ' HB_GTI_DESKTOPDEPTH    ' }, ;
      { '9 ', ' HB_GTI_COMPATBUFFER    ' }, ;
      { '10', ' HB_GTI_KBDSHIFTS       ' }, ;
      { '11', ' HB_GTI_KBDSPECIAL      ' }, ;
      { '12', ' HB_GTI_KBDALT          ' }, ;
      { '13', ' HB_GTI_ISSCREENPOS     ' }, ;
      { '14', ' HB_GTI_KBDSUPPORT      ' }, ;
      { '15', ' HB_GTI_CLIPBOARDDATA   ' }, ;
      { '16', ' HB_GTI_CLIPBOARDPASTE  ' }, ;
      { '19', ' HB_GTI_CURSORBLINKRATE ' }, ;
      { '20', ' HB_GTI_DESKTOPROWS     ' }, ;
      { '21', ' HB_GTI_DESKTOPCOLS     ' }, ;
      { '22', ' HB_GTI_FONTWEIGHT      ' }, ;
      { '23', ' HB_GTI_FONTQUALITY     ' }, ;
      { '24', ' HB_GTI_FONTNAME        ' }, ;
      { '25', ' HB_GTI_CODEPAGE        ' }, ;
      { '26', ' HB_GTI_WINTITLE        ' }, ;
      { '27', ' HB_GTI_ICONFILE        ' }, ;
      { '28', ' HB_GTI_ICONRES         ' }, ;
      { '29', ' HB_GTI_MOUSESTATUS     ' }, ;
      { '30', ' HB_GTI_INPUTFD         ' }, ;
      { '31', ' HB_GTI_OUTPUTFD        ' }, ;
      { '32', ' HB_GTI_ERRORFD         ' }, ;
      { '33', ' HB_GTI_ESCDELAY        ' }, ;
      { '34', ' HB_GTI_VIEWMAXHEIGHT   ' }, ;
      { '35', ' HB_GTI_VIEWMAXWIDTH    ' }, ;
      { '36', ' HB_GTI_VIEWPORTHEIGHT  ' }, ;
      { '37', ' HB_GTI_VIEWPORTWIDTH   ' }, ;
      { '38', ' HB_GTI_STDOUTCON       ' }, ;
      { '39', ' HB_GTI_STDERRCON       ' }, ;
      { '40', ' HB_GTI_ISCTWIN         ' }, ;
      { '41', ' HB_GTI_ISMULTIWIN      ' }, ;
      { '42', ' HB_GTI_GETWIN          ' }, ;
      { '43', ' HB_GTI_SETWIN          ' }, ;
      { '44', ' HB_GTI_NEWWIN          ' }, ;
      { '45', ' HB_GTI_ADDKEYMAP       ' }, ;
      { '46', ' HB_GTI_DELKEYMAP       ' }, ;
      { '47', ' HB_GTI_ISUNICODE       ' }, ;
      { '48', ' HB_GTI_SELECTCOPY      ' }, ;
      { '49', ' HB_GTI_RESIZABLE       ' }, ;
      { '50', ' HB_GTI_CLOSABLE        ' }, ;
      { '51', ' HB_GTI_NOTIFIERBLOCK   ' }, ;
      { '52', ' HB_GTI_SCREENSIZE      ' }, ;
      { '53', ' HB_GTI_PALETTE         ' }, ;
      { '54', ' HB_GTI_RESIZEMODE      ' }, ;
      { '55', ' HB_GTI_SETPOS_XY       ' }, ;
      { '56', ' HB_GTI_SETPOS_ROWCOL   ' }, ;
      { '57', ' HB_GTI_BOXCP           ' }, ;
      { '58', ' HB_GTI_CARGO           ' }, ;
      { '59', ' HB_GTI_FONTSEL         ' }, ;
      { '60', ' HB_GTI_INKEYFILTER     ' }, ;
      { '61', ' HB_GTI_INKEYREAD       ' }, ;
      { '62', ' HB_GTI_ALTENTER        ' }, ;
      { '63', ' HB_GTI_ISFULLSCREEN    ' }, ;
      { '64', ' HB_GTI_ONLINE          ' }, ;
      { '65', ' HB_GTI_VERSION         ' }, ;
      { '66', ' HB_GTI_MAXIMIZED       ' }, ;
      { '67', ' HB_GTI_FONTATTRIBUTE   ' }, ;
      { '68', ' HB_GTI_UNITRANS        ' }, ;
      { '69', ' HB_GTI_WINHANDLE       ' }, ;
      { '70', ' HB_GTI_MOUSEPOS_XY     ' }, ;
      { '71', ' HB_GTI_DISPIMAGE       ' }, ;
      { '72', ' HB_GTI_REDRAWMAX       ' }, ;
      { '73', ' HB_GTI_RESIZESTEP      ' }, ;
      { '74', ' HB_GTI_CLOSEMODE       ' }, ;
      { '75', ' HB_GTI_MINIMIZED       ' }, ;
      { '76', ' HB_GTI_QUICKEDIT       ' }, ;
      { '77', ' HB_GTI_SYSMENUADD      ' }  ;
      }

   ?? '<h1>GT Driver</h1>' + CRLF
   ?? '<h3>Version</h3>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   ?? '<tr><td><b>GT</b></td><td>' + hb_gtVersion( 0 ) + '</td></tr>' + CRLF
   ?? '<tr><td><b>Terminal</b></td><td>' + hb_gtVersion( 1 ) + '</td></tr>' + CRLF
   ?? '</table>' + CRLF
   ?? '<h3>Info GT</h3>' + CRLF
   ?? '<table border=1 cellspacing=2>' + CRLF
   For n := 1 TO Len( aDefs )
      cI := " "
      x  := Val( aDefs[ n ][ 1 ] )
      if x != 42 .and. x != 43 .and. x != 44
         if Valtype( hb_gtInfo( x ) ) = 'N'
            cI  := Str( hb_gtInfo( x ) )
         else
            if Valtype( hb_gtInfo( x ) ) = 'D'
               cI  := DTos( hb_gtInfo( x ) )
            else
               if Valtype( hb_gtInfo( x ) ) = 'L'
                  cI  := if( hb_gtInfo( x ), 'true', 'false' )
               else
                  if Valtype( hb_gtInfo( x ) ) = 'A'
                     AEVal( hb_gtInfo( x ), { | a | cI += if( Valtype( a ) != "C", Str( a ), a ) + "<br>" } )
                  else
                     if Valtype( hb_gtInfo( x ) ) = "P"
                        //cI := HB_Pointer2String( hb_gtInfo( x ), Len( AllTrim( Str( hb_gtInfo( x ) ) ) ) * 2 )
                        cI  := "Pointer / Handle"
                     else
                        if hb_IsNil( hb_gtInfo( x ) )
                           cI := "nil"
                        else
                           cI  := hb_gtInfo( x )
                        endif
                     endif
                  endif
               endif
            endif
         endif
         ?? '<tr><td>' + aDefs[ n ][ 1 ] + '</td><td><b>' + aDefs[ n ][ 2 ] + '</b></td><td>' + cI + '</td></tr>' + CRLF
      endif
   Next n
   ?? '</table>' + CRLF

return nil

//----------------------------------------------------------------------------//

