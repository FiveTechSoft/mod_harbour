// {% hb_SetEnv( "HB_INCLUDE", If( "Linux" $ OS(), "/home/user/harbour/include", If( "Windows" $ OS(), "c:\harbour\include", "/Users/user/harbour/include" ) ) ) %}

STATIC aTtfFontList:= NIL
STATIC cFontDir

//--- problemas con cos,sin 

function Main()
    
   local def_font, tw, i := 0
   local cPageTitle := "Title of the page"
   local font_list := { "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique",;
                        "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Times-Roman",;
                        "Times-Bold", "Times-Italic", "Times-BoldItalic", "Symbol", "ZapfDingbats" }
   local oPrn
   
   oPrn := TPdf():New( "list" )
   oPrn:LoadedFonts := font_list
   if Empty( oPrn:hPdf )
      ? "PDFs not available!"
      return NIL
   endif

   oFont1 := oPrn:DefineFont( 'Helvetica',  24 )
   oFont3 := oPrn:DefineFont( 'Helvetica', 16 )
   oFont2 := oPrn:DefineFont( 'Helvetica-Bold', 16 )
     
   oPrn:StartPage()
    
   height :=  oprn:nVertSize()
   width  :=  oprn:nHorzSize()
   oPrn:Rect( 10, 10, height-20, width-20 ,  1 )
   oPrn:cmSay(  2, 7, cPageTitle, oFont1 )
  
   x = 90

   for n = 1 to Len( font_list )
      samp_text = "abcdefgABCDEFG12345!#$%&+-@?"
      oFont2    = oPrn:DefineFont( font_list[ n ], 16 )     
      oPrn:Say( x + n * 40,  30, font_list[ n ], oFont2 )
      oPrn:Say( x + n * 40, 220, samp_text, oFont2 ) 
   next

   oPrn:EndPage()
   oPrn:Save( hb_GetEnv( "PRGPATH" ) + "/data/test2.pdf" )
   oPrn:end()
   
   ?? "<" + "iframe src='./data/test2.pdf' style='width:calc( 100% + 16px );height:100%;border:0px;margin:-8px;'><" + ;
      "/iframe>"

return nil

//------------------------------------------------------------------------------

#include 'hbclass.ch'
#include 'harupdf.ch'

CLASS TPdf

   DATA hPdf
   DATA hPage
   DATA LoadedFonts
   DATA aPages
   DATA nCurrentPage

   DATA nPageSize INIT HPDF_PAGE_SIZE_A4
   DATA nOrientation INIT HPDF_PAGE_PORTRAIT // HPDF_PAGE_LANDSCAPE
   DATA nHeight, nWidth

   DATA cFileName
   DATA nPermission
   DATA cPassword, cOwnerPassword

   DATA hImageList

   DATA lPreview INIT .F.
   DATA bPreview

   CONSTRUCTOR New( cFileName, cPassword, cOwnerPassword, nPermission, lPreview )
   METHOD SetPage( nPageSize )
   METHOD SetLandscape()
   METHOD SetPortrait()
   METHOD SetCompression( cMode ) INLINE HPDF_SetCompressionMode( ::hPdf, cMode )
   METHOD StartPage()
   METHOD EndPage()
   METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad )
   METHOD CmSay( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad, lO2A )
   METHOD SayRotate( nTop, nLeft, cTxt, oFont, nClrText, nAngle )
   METHOD DefineFont( cFontName, nSize, lEmbed )
   METHOD Cmtr2Pix( nRow, nCol )
   METHOD Mmtr2Pix( nRow, nCol )
   METHOD CmRect2Pix( aRect )
   METHOD nVertRes() INLINE 72
   METHOD nHorzRes() INLINE 72
   METHOD nLogPixelX() INLINE 72  // Number of pixels per logical inch
   METHOD nLogPixelY() INLINE 72
   METHOD nVertSize() INLINE HPDF_Page_GetHeight( ::hPage )
   METHOD nHorzSize() INLINE HPDF_Page_GetWidth( ::hPage )
   METHOD SizeInch2Pix( nHeight, nWidth )
   METHOD CmSayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster, lStrech )
   METHOD SayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster )
   METHOD GetImageFromFile( cImageFile )
   METHOD Line( nTop, nLeft, nBottom, nRight, oPen )
   METHOD CmLine( nTop, nLeft, nBottom, nRight, oPen )
   METHOD Rect( nTop, nLeft, nBottom, nRight, oPen, nColor )
   METHOD CmRect( nTop, nLeft, nBottom, nRight, oPen, nColor )
   MESSAGE Box METHOD Rect
   MESSAGE CmBox METHOD CmRect
   METHOD RoundBox( nTop, nLeft, nBottom, nRight, nWidth, nHeight, oPen, nColor, nBackColor, lFondo )
   METHOD CmRoundBox( nTop, nLeft, nBottom, nRight, nWidth, nHeight, oPen, nColor, nBackColor, lFondo )
   MESSAGE RoundRect METHOD RoundBox
   MESSAGE CmRoundRect METHOD CmRoundBox

   METHOD SetPen( oPen, nColor )
   METHOD SetRGBStroke( nColor )
   METHOD SetRGBFill( nColor )

   METHOD DashLine( nTop, nLeft, nBottom, nRight, oPen, nDashMode )
   METHOD CmDashLine( nTop, nLeft, nBottom, nRight, oPen, nDashMode )
   METHOD Save( cFilename )
   METHOD SyncPage()
   METHOD CheckPage()
   METHOD GetTextWidth( cText, oFont )
   METHOD GetTextHeight( cText, oFont )

   METHOD End()

ENDCLASS

//------------------------------------------------------------------------------

METHOD New( cFileName, cPassword, cOwnerPassword, nPermission, lPreview ) CLASS TPdf

   ::hPdf := HPDF_New()
   ::LoadedFonts := {}

   if ::hPdf == NIL
      ? "Pdf could not been created!"
      return NIL
   endif

   HPDF_SetCompressionMode( ::hPdf, HPDF_COMP_ALL )

   ::cFileName := cFileName
   ::cPassword := cPassword
   ::cOwnerPassword := cOwnerPassword
   ::nPermission := nPermission

   ::hImageList := { => }
   ::aPages := {}
   ::nCurrentPage := 0

   // Mastintin
   if HB_ISLOGICAL( lPreview )
      ::lPreview:= lPreview
    //  ::bPreview := { || HaruShellexecute( NIL, "open", ::cFileName ) }
   endif

return Self

//------------------------------------------------------------------------------

METHOD SetPage( nPageSize ) CLASS TPdf

   ::nPageSize:= nPageSize
   ::SyncPage()

return Self

//------------------------------------------------------------------------------

METHOD SyncPage() CLASS TPdf

   if ::hPage != NIL
      HPDF_Page_SetSize( ::hPage, ::nPageSize, ::nOrientation )
      ::nHeight := HPDF_Page_GetHeight( ::hPage )
      ::nWidth  := HPDF_Page_GetWidth( ::hPage )
   endif

return NIL

//------------------------------------------------------------------------------

METHOD CheckPage() CLASS TPdf

   if ::hPage == NIL
      ::StartPage()
   endif

return NIL

//------------------------------------------------------------------------------

METHOD SetLandscape() CLASS TPdf

   ::nOrientation:= HPDF_PAGE_LANDSCAPE
   ::SyncPage()

return Self

//------------------------------------------------------------------------------

METHOD SetPortrait() CLASS TPdf

   ::nOrientation:= HPDF_PAGE_PORTRAIT
   ::SyncPage()

return Self

//------------------------------------------------------------------------------

METHOD StartPage() CLASS TPdf

   ::hPage := HPDF_AddPage( ::hPdf )
   AAdd( ::aPages, ::hPage )
   ::nCurrentPage := Len( ::aPages )
   ::SyncPage()

return Self

//------------------------------------------------------------------------------

METHOD EndPage() CLASS TPdf

   ::hPage := NIL

return Self

//------------------------------------------------------------------------------

METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad ) CLASS TPdf

   local c, nTextHeight

   ::CheckPage()
   HPDF_Page_BeginText( ::hPage )

   if oFont == NIL
      nTextHeight := HPDF_Page_GetCurrentFontSize( ::hPage )
   ELSE
      HPDF_Page_SetFontAndSize( ::hPage, oFont[ 1 ], oFont[ 2 ] )
      nTextHeight := oFont[ 2 ]
   endif

   if ValType( nClrText ) == 'N'
      c := HPDF_Page_GetRGBFill( ::hPage )
      ::SetRGBFill( nClrText )
   endif

   DO CASE
   CASE nPad == NIL .OR. nPad == HPDF_TALIGN_LEFT
      HPDF_Page_TextOut( ::hPage, nCol, ::nHeight - nRow - nTextHeight, cText )
   CASE nPad == HPDF_TALIGN_RIGHT
      nWidth := HPDF_Page_TextWidth( ::hPage, cText )
      HPDF_Page_TextOut( ::hPage, nCol - nWidth, ::nHeight - nRow - nTextHeight, cText )
   OTHER
      nWidth := HPDF_Page_TextWidth( ::hPage, cText )
      HPDF_Page_TextOut( ::hPage, nCol - nWidth / 2, ::nHeight - nRow - nTextHeight, cText )
   ENDCASE

   if ValType( c ) == 'A'
      HPDF_Page_SetRGBFill( ::hPage, c[ 1 ], c[ 2 ], c[ 3 ] )
   endif
   HPDF_Page_EndText( ::hPage )

return Self

//------------------------------------------------------------------------------

METHOD CmSay( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad, lO2A ) CLASS TPdf

   ::Cmtr2Pix( @nRow, @nCol )
   if nWidth != Nil
      ::Cmtr2Pix( 0, @nWidth )
   endif
   ::Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad, lO2A )

return Self

//------------------------------------------------------------------------------

METHOD DefineFont( cFontName, nSize, lEmbed ) CLASS TPdf

   local font_list  := { ;
                        "Courier",                  ;
                        "Courier-Bold",             ;
                        "Courier-Oblique",          ;
                        "Courier-BoldOblique",      ;
                        "Helvetica",                ;
                        "Helvetica-Bold",           ;
                        "Helvetica-Oblique",        ;
                        "Helvetica-BoldOblique",    ;
                        "Times-Roman",              ;
                        "Times-Bold",               ;
                        "Times-Italic",             ;
                        "Times-BoldItalic",         ;
                        "Symbol",                   ;
                        "ZapfDingbats"              ;
                      }

   local i, ttf_list

   i := aScan( font_list, {|x| Upper( x ) == Upper( cFontName ) } )
   if i > 0 // Standard font
      cFontName:= font_list[ i ]
   ELSE
      i := aScan( ::LoadedFonts, {|x| Upper( x[ 1 ] ) == Upper( cFontName ) } )
      if i > 0
         cFontName := ::LoadedFonts[ i ][ 2 ]
         //DEBUGMSG 'Activada fuente ' + cFontName
      ELSE
         ttf_list := GetHaruFontList()
         i := aScan( ttf_list, {|x| Upper( x[ 1 ] ) == Upper( cFontName ) } )
         if i > 0
            cFontName := HPDF_LoadTTFontFromFile( ::hPdf, ttf_list[ i, 2 ], lEmbed )
            //DEBUGMSG 'Cargada fuente ' + cFontName
            //DEBUGMSG 'Fichero ' + ttf_list[ i, 2 ]
            AAdd( ::LoadedFonts, { ttf_list[ i, 1 ], cFontName } )
         ELSE
            Alert( 'Fuente desconocida '+cFontName )
            return NIL
         endif
      endif
   endif

return { HPDF_GetFont( ::hPdf, cFontName, "WinAnsiEncoding" ), nSize }

//------------------------------------------------------------------------------

METHOD Cmtr2Pix( nRow, nCol ) CLASS TPdf

   nRow *= 72 / 2.54
   nCol *= 72 / 2.54

return { nRow, nCol }

//------------------------------------------------------------------------------

METHOD Mmtr2Pix( nRow, nCol ) CLASS TPdf

   nRow *= 72 / 25.4
   nCol *= 72 / 25.4

 return { nRow, nCol }

//------------------------------------------------------------------------------

METHOD CmRect2Pix( aRect ) CLASS TPdf

   local aTmp[ 4 ]

   aTmp[ 1 ] = Max( 0, aRect[ 1 ] * 72 / 2.54 )
   aTmp[ 2 ] = Max( 0, aRect[ 2 ] * 72 / 2.54 )
   aTmp[ 3 ] = Max( 0, aRect[ 3 ] * 72 / 2.54 )
   aTmp[ 4 ] = Max( 0, aRect[ 4 ] * 72 / 2.54 )

return aTmp

//------------------------------------------------------------------------------

METHOD SizeInch2Pix( nHeight, nWidth ) CLASS TPdf

   nHeight *= 72
   nWidth *= 72

return { nHeight, nWidth }

//------------------------------------------------------------------------------

METHOD GetImageFromFile( cImageFile ) CLASS TPdf

   if hb_HHasKey( ::hImageList, cImageFile )
      return ::hImageList[ cImageFile ]
   endif
   if ! File( cImageFile )
      IF( Lower( Right( cImageFile, 4 ) ) == '.bmp' ) // En el c�digo esta como bmp, probar si ya fue transformado a png
         cImageFile := Left( cImageFile, Len( cImageFile ) - 3 ) + 'png'
         return ::GetImageFromFile( cImageFile )
      ELSE
         ? cImageFile + ' not found'
         return NIL
      endif
   endif
   IF( Lower( Right( cImageFile, 4 ) ) == '.png' )
      return ( ::hImageList[ cImageFile ] := HPDF_LoadPngImageFromFile(::hPdf, cImageFile ) )
   endif

return ::hImageList[ cImageFile ] := HPDF_LoadJpegImageFromFile(::hPdf, cImageFile )

//------------------------------------------------------------------------------

METHOD SayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster ) CLASS TPdf

   local image

   if !Empty( image := ::GetImageFromFile( xBitmap ) )
      HPDF_Page_DrawImage( ::hPage, image, nCol, ::nHeight - nRow - nHeight, nWidth, nHeight /* iw, ih*/)
   endif

return Self

//------------------------------------------------------------------------------

METHOD Line( nTop, nLeft, nBottom, nRight, oPen ) CLASS TPdf

   if oPen != NIL
      ::SetPen( oPen )
   endif

   HPDF_Page_MoveTo ( ::hPage, nLeft, ::nHeight - nTop )
   HPDF_Page_LineTo ( ::hPage, nRight, ::nHeight - nBottom )
   HPDF_Page_Stroke ( ::hPage )

return Self

//------------------------------------------------------------------------------

METHOD Save( cFilename ) CLASS TPdf

   FErase( cFilename )

   if ValType( ::nPermission ) != 'N'
      ::nPermission := ( HPDF_ENABLE_READ + HPDF_ENABLE_PRINT + HPDF_ENABLE_COPY )
   endif

   if ValType( ::cPassword ) == 'C' .AND. !Empty( ::cPassword )
      if Empty( ::cOwnerPassword )
         ::cOwnerPassword := ::cPassword + '+1'
      endif
      HPDF_SetPassword( ::hPdf, ::cOwnerPassword, ::cPassword )
      HPDF_SetPermission( ::hPdf, ::nPermission )
   endif

return HPDF_SaveToFile ( ::hPdf, cFilename )

//------------------------------------------------------------------------------

METHOD GetTextWidth( cText, oFont ) CLASS TPdf

   HPDF_Page_SetFontAndSize( ::hPage, oFont[ 1 ], oFont[ 2 ] )

return HPDF_Page_TextWidth( ::hPage, cText )

//------------------------------------------------------------------------------

METHOD GetTextHeight( cText, oFont ) CLASS TPdf

   HPDF_Page_SetFontAndSize( ::hPage, oFont[ 1 ], oFont[ 2 ] )

return oFont[ 2 ] // height of the font when we create it

//------------------------------------------------------------------------------

METHOD End() CLASS TPdf

   local nResult

   if ValType( ::cFileName ) == 'C'
      nResult := ::Save( ::cFileName )
   endif

   HPDF_Free( ::hPdf )

   ::aPages := {}

   if ::lPreview
      Eval( ::bPreview, Self )
   endif

return nResult

//------------------------------------------------------------------------------

METHOD Rect( nTop, nLeft, nBottom, nRight, oPen, nColor ) CLASS TPdf

   HPDF_Page_GSave( ::hPage )
   ::SetPen( oPen, nColor )

   HPDF_Page_Rectangle( ::hPage, nLeft, ::nHeight - nBottom, nRight - nLeft,  nBottom - nTop )

   HPDF_Page_Stroke ( ::hPage )
   HPDF_Page_GRestore( ::hPage )

return Self


METHOD CmRect( nTop, nLeft, nBottom, nRight, oPen, nColor ) CLASS TPdf

   ::Rect( nTop * 72 / 2.54, nLeft * 72 / 2.54, nBottom * 72 / 2.54, nRight * 72 / 2.54, oPen, nColor )

return Self

METHOD CmLine( nTop, nLeft, nBottom, nRight, oPen ) CLASS TPdf

   ::Line( nTop * 72 / 2.54, nLeft * 72 / 2.54, nBottom * 72 / 2.54, nRight * 72 / 2.54, oPen )

return Self

METHOD CmDashLine( nTop, nLeft, nBottom, nRight, oPen, nDashMode ) CLASS TPdf

   ::DashLine( nTop * 72 / 2.54, nLeft * 72 / 2.54, nBottom * 72 / 2.54, nRight * 72 / 2.54, oPen, nDashMode )

return Self

METHOD DashLine( nTop, nLeft, nBottom, nRight, oPen, nDashMode ) CLASS TPdf

   HPDF_Page_SetDash( ::hPage, { 3, 7 }, 2, 2 )
   ::Line( nTop, nLeft, nBottom, nRight, oPen )
   HPDF_Page_SetDash( ::hPage, NIL, 0, 0 )

return Self

//------------------------------------------------------------------------------

METHOD CmSayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster, lStrech  ) CLASS TPdf

   if !Empty(  nWidth  )
     nWidth := nWidth * 72 / 2.54
   endif

   if !Empty(  nHeight  )
      nHeight := nHeight * 72 / 2.54
   endif

   ::SayBitmap( nRow * 72 / 2.54, nCol * 72 / 2.54, xBitmap, nWidth, nHeight, nRaster, lStrech )

return nil 

//------------------------------------------------------------------------------

METHOD RoundBox( nTop, nLeft, nBottom, nRight, nWidth, nHeight, oPen, nColor, nBackColor ) CLASS TPdf

   local nRay
   local xposTop, xposBotton
   local nRound

   HB_DEFAULT( @nWidth, 0 )
   HB_DEFAULT( @nHeight, 0 )

      nRound:= Min( nWidth, nHeight )

      nRound := nRound / 250

   HPDF_Page_GSave(::hPage)
   ::SetPen( oPen, nColor )

   if HB_ISNUMERIC( nBackColor )
      ::SetRGBFill( nBackColor )
   endif

   if Empty( nRound )
      HPDF_Page_Rectangle( ::hPage, nLeft, ::nHeight - nBottom, nRight - nLeft,  nBottom - nTop )
   ELSE
      nRay = Round( iif( ::nWidth > ::nHeight, Min( nRound,Int( (nBottom - nTop ) / 2 ) ), Min( nRound,Int( (nRight - nLeft) / 2 ) ) ), 0 )

      xposTop := ::nHeight - nTop
      xposBotton := ::nHeight - nBottom

      HPDF_Page_MoveTo ( ::hPage, nLeft + nRay,  xposTop )
      HPDF_Page_LineTo ( ::hPage, nRight - nRay, xposTop )

      HPDF_Page_CurveTo( ::hPage, nRight, xposTop, nRight,  xposTop, nRight,  xposTop - nRay )

      HPDF_Page_LineTo ( ::hPage, nRight, xposBotton + nRay )
      HPDF_Page_CurveTo( ::hPage, nRight, xposBotton, nRight, xposBotton, nRight - nRay,  xposBotton  )
      HPDF_Page_LineTo ( ::hPage, nLeft + nRay, xposBotton )
      HPDF_Page_CurveTo( ::hPage, nLeft, xposBotton,  nLeft, xposBotton, nLeft, xposBotton + nRay )

      HPDF_Page_LineTo ( ::hPage, nLeft, xposTop - nRay )
      HPDF_Page_CurveTo( ::hPage, nLeft, xposTop,  nLeft, xposTop, nLeft + nRay, xposTop )
   endif

   if HB_ISNUMERIC( nBackColor )
      HPDF_Page_FillStroke ( ::hPage )
   ELSE
      HPDF_Page_Stroke ( ::hPage )
   endif
   HPDF_Page_GRestore( ::hPage )

return Self

//------------------------------------------------------------------------------

METHOD SetPen( oPen, nColor ) CLASS TPdf

   if oPen != NIL
      if ValType( oPen ) == 'N'
         HPDF_Page_SetLineWidth( ::hPage, oPen )
      ELSE
         HPDF_Page_SetLineWidth( ::hPage, oPen:nWidth )
         nColor:= oPen:nColor
      endif
   endif

   if ValType( nColor ) == 'N'
      ::SetRGBStroke( nColor )
   endif

return SELF

//------------------------------------------------------------------------------

METHOD SetRGBStroke( nColor ) CLASS TPdf

  HPDF_Page_SetRGBStroke( ::hPage, ( nColor  % 256 ) / 256.00,;
                                   ( Int( nColor / 0x100 )  % 256 ) / 256.00,;
                                   ( Int( nColor / 0x10000 ) % 256 ) / 256.00 )
return NIL

//------------------------------------------------------------------------------

METHOD SetRGBFill( nColor ) CLASS TPdf

    HPDF_Page_SetRGBFill( ::hPage, HB_BitAnd( Int( nColor ), 0xFF ) / 255.00,;
                                   HB_BitAnd( HB_BitShift( Int( nColor ), -8 ), 0xFF ) / 255.00,;
                                   HB_BitAnd( HB_BitShift( Int( nColor ), -16 ), 0xFF ) / 255.00 )


//  HPDF_Page_SetRGBFill( ::hPage,  nRGBRed( nColor ) / 255.00,;
//                                  nRGBGeen( nColor ) / 255.00,;
//                                  nRGBBlue( nColor ) / 255.00 )

//  HPDF_Page_SetRGBFill( ::hPage, ( nColor  % 256 ) / 256.00,;
//                                  ( Int( nColor / 0x100 )  % 256 ) / 256.00,;
//                                  ( Int( nColor / 0x10000 ) % 256 ) / 256.00 )

return NIL

//------------------------------------------------------------------------------

METHOD CmRoundBox( nTop, nLeft, nBottom, nRight, nWidth, nHeight, oPen, nColor, nBackColor, lFondo ) ;
   CLASS TPdf

   DEFAULT nWidth To 0, nHeight TO 0

return ::RoundBox( nTop * 72 / 2.54, nLeft * 72 / 2.54, nBottom * 72 / 2.54, nRight * 72 / 2.54,;
       nWidth * 72 / 2.54 , nHeight * 72 / 2.54 , oPen, nColor, nBackColor, lFondo )

//------------------------------------------------------------------------------

METHOD SayRotate( nTop, nLeft, cTxt, oFont, nClrText, nAngle ) CLASS TPdf

   local aBackColor
   local nRadian := ( nAngle / 180 ) * 3.141592 /* Calcurate the radian value. */

    if ValType( nClrText ) == 'N'
       aBackColor:= HPDF_Page_GetRGBFill( ::hPage )
      ::SetRGBFill( nClrText )
   endif

   /* FONT and SIZE*/
   if !Empty( oFont )
       HPDF_Page_SetFontAndSize( ::hPage, oFont[1], oFont[2] )
   EndI

   /* Rotating text */
   HPDF_Page_BeginText( ::hPage )
//   HPDF_Page_SetTextMatrix( ::hPage, cos( nRadian ),;
//                                     sin( nRadian ),;
//                                     -( sin( nRadian ) ),;
//                                     cos( nRadian ), nLeft, HPDF_Page_GetHeight( ::hPage )-( nTop ) )
   HPDF_Page_ShowText( ::hPage, cTxt )

   if ValType( aBackColor ) == 'A'
      HPDF_Page_SetRGBFill( ::hPage, aBackColor[1], aBackColor[2], aBackColor[3] )
   endif

   HPDF_Page_EndText( ::hPage )

return NIL

//------------------------------------------------------------------------------

FUNCTION SetHaruFontDir(cDir)

   local cPrevValue:= cFontDir
   if ValType( cDir ) == 'C' .AND. HB_DirExists( cDir )
      cFontDir:= cDir
   endif

return cPrevValue

//------------------------------------------------------------------------------

FUNCTION GetHaruFontDir()

#define CSIDL_FONTS 0x0014

   if cFontDir == NIL
    //  cFontDir:= HaruGetSpecialFolder( CSIDL_FONTS )
   endif

return cFontDir

//------------------------------------------------------------------------------

FUNCTION GetHaruFontList()

   if aTtfFontList == NIL
      InitTtfFontList()
   endif

return aTtfFontList

//------------------------------------------------------------------------------

STATIC FUNCTION InitTtfFontList()

   local aDfltList:= { { 'Arial', 'arial.ttf' } ;
                     , { 'Verdana', 'verdana.ttf' } ;
                     , { 'Courier New', 'cour.ttf' } ;
                     , { 'Calibri', 'calibri.ttf' } ;
                     , { 'Tahoma', 'tahoma.ttf' } ;
                     }

   aTtfFontList:= {}
   aEval( aDfltList, {|_x| HaruAddFont( _x[1], _x[2] ) } )

return NIL

//------------------------------------------------------------------------------

FUNCTION HaruAddFont( cFontName, cTtfFile )

   local aList := GetHaruFontList()

   if !File( cTtfFile ) .AND. File( GetHaruFontDir() + '\' + cTtfFile )
      cTtfFile:= GetHaruFontDir() + '\' + cTtfFile
   endif
   if File( cTtfFile )
      aAdd( aList, { cFontName, cTtfFile } )
   ELSE
      ? 'file not found ' + cTtfFile
   endif

return NIL

//------------------------------------------------------------------------------
