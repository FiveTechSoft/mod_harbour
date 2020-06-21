function Main()

   local pdf    := HPDF_New()
   local page   := HPDF_AddPage( pdf )
   local height := HPDF_Page_GetHeight( page )
   local width  := HPDF_Page_GetWidth( page )
   local def_font, tw, i := 0
   local cPageTitle := "Title of the page"
   local font_list := { "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique",;
                        "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Times-Roman",;
                        "Times-Bold", "Times-Italic", "Times-BoldItalic", "Symbol", "ZapfDingbats" }
   
   HPDF_Page_SetLineWidth( page, 1 )
   HPDF_Page_Rectangle( page, 50, 50, width - 100, height - 110 )
   HPDF_Page_Stroke( page )

   def_font = HPDF_GetFont( pdf, "Helvetica" )
   HPDF_Page_SetFontAndSize( page, def_font, 24 )
   
   tw = HPDF_Page_TextWidth( page, cPageTitle )
   HPDF_Page_BeginText( page )
   HPDF_Page_TextOut( page, ( width - tw ) / 2, height - 50, cPageTitle )
   HPDF_Page_EndText( page )

   HPDF_Page_BeginText( page )
   HPDF_Page_SetFontAndSize( page, def_font, 16 )
   HPDF_Page_TextOut( page, 60, height - 80, "" )
   HPDF_Page_EndText( page )

   HPDF_Page_BeginText( page )
   HPDF_Page_MoveTextPos( page, 60, height - 105 )

   for n = 1 to Len( font_list )
      samp_text = "abcdefgABCDEFG12345!#$%&+-@?"
      font = HPDF_GetFont( pdf, font_list[ n ] )

      HPDF_Page_SetFontAndSize( page, def_font, 9 )
      HPDF_Page_ShowText( page, font_list[ n ] )
      HPDF_Page_MoveTextPos( page, 0, -18 )

      HPDF_Page_SetFontAndSize( page, font, 20 )
      HPDF_Page_ShowText( page, samp_text )
      HPDF_Page_MoveTextPos( page, 0, -20 )
   next

   HPDF_Page_EndText( page )
   HPDF_SaveToFile( pdf, hb_GetEnv( "PRGPATH" ) + "/data/test.pdf" )
   HPDF_Free( pdf )   
   
   ?? "<" + "iframe src='./data/test.pdf' style='width:calc( 100% + 16px );height:100%;border:0px;margin:-8px;'><" + "/iframe>"

return nil
