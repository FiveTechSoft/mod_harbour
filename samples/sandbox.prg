//----------------------------------------------------------------------------//
//
// Author : ( c ) Antonio Linares & Cristobal Navarro
// Date   : 14/06/2019
// Version: 1.0
//
//----------------------------------------------------------------------------//

#xcommand TEXT INTO <v> => #pragma __cstream|<v>:=%s
#xcommand TEXT INTO <v> ADDITIVE => #pragma __cstream|<v>+=%s
#xcommand TEXT TO VAR <var> => #pragma __stream|<var>:=%s
#xcommand ENDTEXT => #pragma __endtext

Static cText        := ""
Static cIni         := ""
Static hIni         := ""

function Main( cFile )

   local cDateBuild := "Jun 18 2019 11:06:00"
   local cTabFile   := "NONAME1.PRG"
   local cToolTab   := AP_GetEnv( "DOCUMENT_ROOT" ) + "\modharbour_samples\" 
   local oEditor
   cIni   := AP_GetEnv( "DOCUMENT_ROOT" ) + "\modharbour_samples\" + "xcloud.ini"
   cIni   := StrTran( cIni, "\", "\\" )
   cIni   := StrTran( cIni, "/", "\\" )
   cIni   := StrTran( cIni, "\", "/" )
   hIni   := ConfigRead( cIni )

   cText  := GetTextInitial()

   if Len( hb_aParams() ) > 0
      if !Empty( At( "source=", cFile ) )
         cFile := StrTran( cFile, "source=", "" )
      endif
      if Empty( At( "http", cFile ) ) .and. File( cFile )
         cText    := MemoRead( cFile )
         cTabFile := HB_FNameNameExt( cFile )
         cToolTab := HB_FNameDir( cFile )
         cToolTab := StrTran( cToolTab, "\", "\\" )
      else
         if !Empty( hb_aParams()[ 1 ] )
            cText    := ""
            cTabFile := HB_FNameNameExt( cFile )
            cToolTab := cFile
            cToolTab := StrTran( cToolTab, "\", "\\" )
         else
            cToolTab := StrTran( cToolTab, "\", "/" )
         endif
      endif
   endif

   cText  := FHtmlEncode( cText )

   TEMPLATE USING oEditor PARAMS cText, cTabFile, cToolTab, cIni, cDateBuild
   <html lang="en">
   <html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, shrink-to-fit=no">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
      <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
      <title>XCloud V.1.1</title>
      <meta name="author" content="Cristobal Navarro">

   <style>
   .container-fluid {
      color:#2C2828;
      background-color:Ivory;
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
   }

   #editor { 
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 15;
      padding-top: 0px;
      padding-left: 0px;
      padding-right: 0px;
      padding-bottom: 0px;
   }

   #tabs { 
      position: relative;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      padding-top: 0px;
      padding-left: 0px;
      padding-right: 0px;
      padding-bottom: 0px;
   }

   .col-md-6 {
      padding-top: 0px; 
      padding-bottom: 0px;
      padding-left: 4px; 
      padding-right: 4px;
      color: #2C2828;
      background-color: #ffff;
   }

   .btn {
      color:white;
      background-color:#002240;
   }

   .btn:hover {
      color: #002240;
      background-color: #FFFF;
   }

   .btn:focus {
      color: #2C2828;
      background-color: #FFFF;
   }

   .vsplitbar {
   	width: 4px;
   	background: #92A8D1;
   }

   body {
      background-color: Ivory;
      font-family: "Helvetica";
   }

   .nav-tabs > li {
      margin-left:0px;
      position:relative;
      font-size: 14px;
      font-family: "Segoe UI Symbol";
   }

   .nav-tabs > li > a
      {
      padding-top: 5px; 
      padding-bottom: 5px;
      padding-right: 25px;
      color:#2C2828;
      background-color: lightgray;
      display:inline-block;
   }

   .nav-tabs > li > span {
       display:none;
       cursor:pointer;
       position:absolute;
       right: 10px;
       top: 5px;
       color: red;
   }

   .nav-tabs > li:hover > span {
       display: inline-block;
   }

   .nav-tabs > li.active > a {
      color:#2C2828;
      background-color:#FFF29D;
   }

   .nav-tabs > li.active > a:focus {
      color:white;
      background-color: #002240;
   }

   .nav-tabs > li.active > a:hover {
      color:white;
      background-color:gray;
   }

   .close {
      color: #ffff; 
      opacity: 1;
   }
   </style>
   </head>

   <body>
      <nav class="navbar navbar-inverse" style="border:0px;height:7.5%;">
         <div class="container-fluid"
            style="background-color:#92A8D1;border:0px;height:100%;">
            <div class="navbar-header">
               <a class="navbar-brand" href="https://fivetechsoft.github.io/mod_harbour/"
                  style="color:#002240;padding-top:4px;padding-left:20px;padding-right:14px;padding-bottom:4px;">
                  <span class="glyphicon glyphicon-menu-hamburger" height="46" aria-hidden="true"></span>
                  <b>xcloud v.1.1</b><p><h5><b>Ide for mod_harbour</b></h5></p></a>
            </div>
            <div class="nav navbar-nav">
               <div class="col-sm-1">
               <input type="file" directory class="btn navbar-btn btn-md btn-sm" name="SelectFile" id="selectfile"
                  accept=".prg,.ch,.h,.c,.cpp,.view,.html,.htm,.php*,.tpl,.js,.css"
                  onchange="openFile(event)"><br>
               </div>
               <a class="navbar-brand" href="#"></a>
               <ul class="nav navbar-nav navbar-right">
                  <li><button class="btn navbar-btn btn-sm" onclick="editor_run()" title="[ F9 ]"><span class="glyphicon glyphicon-flash"></span> Run</button></li>
                  <li><button class="btn navbar-btn btn-sm" onclick="Download()" title="[ Ctrl + S ]">
                      <span class="glyphicon glyphicon-cloud-download"></span> Save</button></li>
                  <li><button class="btn navbar-btn btn-sm"  onclick="$('#saveas').modal()" title="[ Ctrl + Q ]">
                      <span class="glyphicon glyphicon-save"></span> Save As</button></li>
                  <a class="navbar-brand" href="#"></a>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="Clear()" title="[ F5 ]"><span class="glyphicon glyphicon-edit"></span> Clear All</button></li>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="Clear( true )" title="[ F7 ]"><span class="glyphicon glyphicon-inbox"></span> Clear Result</button></li>
                  <a class="navbar-brand" href="#"></a>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="$('#gotoline').modal()" title="[ F6 ]"><span class="glyphicon glyphicon-edit"></span> Go to</button></li>
                  <a class="navbar-brand" href="#"></a>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="editor.undo()" title="[ Ctrl + Z ]"><span class="glyphicon glyphicon-repeat"></span> Undo</button></li>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="editor.redo()" title="[ Ctrl + A ]"><span class="glyphicon glyphicon-refresh"></span> Redo</button></li>
                  <a class="navbar-brand" href="#"></a>
                  <li><button class="btn navbar-btn btn-md btn-sm" 
                       onclick='editor.execCommand("showSettingsMenu")' title="[ CTRL + , ]">
                       <span class="glyphicon glyphicon glyphicon-cog"></span> Setup</button></li>
                  <li><button class="btn navbar-btn btn-sm" 
                       onclick='editor.execCommand("showKeyboardShortcuts")' title="[ CTRL + ALT + H ]">
                       <span class="glyphicon glyphicon-question-sign"></span> Help</button></li>
                  <li><button class="btn navbar-btn btn-sm" onclick="$('#about').modal()">
                       <span class="glyphicon glyphicon-info-sign"></span> About</button></li>
                  <a class="navbar-brand" href="#"></a>
                  <li><button class="btn navbar-btn btn-md btn-sm" onclick="openfileconfig()" title="[      +   ]"><span class="glyphicon glyphicon-exclamation-sign"></span> Config</button></li>
               </ul>
            </div>
         </div>
      </nav>
      <ul class="nav nav-tabs" id="tabs" role="tablist" style="background-color:Ivory;">
         <li class="active" id="tab1"><a data-toggle="tab" href="#row1" role="tab" title="<?prg return cToolTab ?>">
            <?prg return cTabFile ?></a><span>x</span></li>
      </ul>
      <div class="tab-content" style="background-color:Ivory;width:100%;height:88.0%;">
         <div class="row" id="row1" style="background-color:Ivory;width:100%;height:100%;">
            <div class="col-sm-7" style="background-color:Ivory;width:100%;height:100%;">
               <div id="editor" style="height:100%;"><?prg return cText ?></div>
            </div>
            <div class="col-sm" id="result"
               style="border:0.5px solid;border-color:#92A8D1;background-color:Ivory;height:100%;padding-left:5px;">
            </div>
         </div>
      </div>

      <div class="modal fade" id="gotoline" role="dialog">
        <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">Goto Line / Column:</h4>
            </div>
            <div class="modal-body" style="padding:40px 50px;">
              <form role="form">
                <div class="form-group">
                  <label for="goline"><span class="glyphicon glyphicon glyphicon-arrow-down"></span> Number Line</label>
                  <input type="text" class="form-control" id="goline" placeholder="Enter Line">
                </div>
                <div class="form-group">
                  <label for="gocol"><span class="glyphicon glyphicon glyphicon-arrow-right"></span> Number Column</label>
                  <input type="text" class="form-control" id="gocol" placeholder="Enter Column">
                </div>
                <button class="btn btn-success btn-block" data-dismiss="modal" onclick="GotoLine()">
                   <span class="glyphicon glyphicon-saved"></span> Go To</button>
              </form>
            </div>
          </div>
        </div>
      </div> 

      <div class="modal fade" id="saveas" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">Save As:</h4>
            </div>
            <div class="modal-body" style="padding:40px 50px;">
              <form role="form">
                <div class="form-group">
                  <label for="filesave"><span class="glyphicon glyphicon-download-alt"></span> Name File</label>
                  <input type="text" class="form-control" id="filesave" placeholder="Enter file">
                </div>
                <button class="btn btn-success btn-block" data-dismiss="modal" onclick="SaveFileAs()">
                   <span class="glyphicon glyphicon-saved"></span> Save</button>
              </form>
            </div>
          </div>
        </div>
      </div> 
      
      <div class="modal fade" id="about" role="dialog">
        <div class="modal-dialog modal-sl">
          <div class="modal-content">
            <div class="modal-header" style="color:#2C2828;background-color:silver;padding:4px 4px;">
              <button type="button" class="close" data-dismiss="modal" style="color:white;padding:4px 4px;">&times;</button>
              <h4 class="modal-title"><b>xcloud v.1.1 - Ide & Editor for mod_harbour</b> [ <?prg return cDateBuild ?> ]</h4>
            </div>
            <div class="modal-body" style="color:#2C2828;background-color:white;padding:4px 20px 4px;">
              <h6>
              <div class="row">
              <div class="col-md-6" <p><b>[ F2  ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F3  ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F4  ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F5  ]</b></p></div><div class="col-md-6" <p> : CLEAN ALL </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F6  ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F7  ]</b></p></div><div class="col-md-6" <p> : CLEAN ONLY RESULTS</p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F8  ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F9  ]</b></p></div><div class="col-md-6" <p> : RUN </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F10 ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F11 ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ F12 ]</b></p></div><div class="col-md-6" <p> : </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + A</b></p></div><div class="col-md-6" <p> : SELECT ALL </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + C</b></p></div><div class="col-md-6" <p> : COPY </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + F</b></p></div><div class="col-md-6" <p> : SEARCH </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + H</b></p></div><div class="col-md-6" <p> : REPLACE </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + S</b></p></div><div class="col-md-6" <p> : SAVE </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + V</b></p></div><div class="col-md-6" <p> : PASTE </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + X</b></p></div><div class="col-md-6" <p> : CUT </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL         ] + Z</b></p></div><div class="col-md-6" <p> : UNDO </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL + SHIFT ] + Z</b></p></div><div class="col-md-6" <p> : REDO </p></div>
              </div>
              <div class="row">
              <div class="col-md-6" <p><b>[ CTRL + ALT   ] + H</b></p></div><div class="col-md-6" <p> : SHOWKEYBOARDSHORTCUTS</p></div></h6>
              </div>
            </div>
            <div class="modal-footer" style="color:white;background-color:#2C2828;padding:4px 4px;">
            <h5 class="modal-title"><b>(c) Antonio Linares & Cristobal Navarro</b></h5>
            </div>
          </div>
        </div>
      </div> 

      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
      <script src="https://fivetechsoft.github.io/xcloud/demo/kitchen-sink/require.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ext-modelist.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ext-emmet.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ext-language_tools.js"></script>
      <script>
         var ctab = "" ;
         var textos = [];
         var npossplitter = <?prg return GetKeyIni( , "possplitter" ) ?>;
         var editor = ace.edit('editor');
         ctab = $('#tabs a:last').text().trim().toUpperCase();
         textos[ ctab ] = editor.getValue();

         editor.commands.removeCommand('jumptomatching');

         // Default value is the first one in comments
         // All options are set to default value
         editor.setOptions({
            // editor options
            selectionStyle: <?prg return GetKeyIni( , "selectionStyle" ) ?>,// "line"|"text"  <?prg return GetKeyIni( , "selectionStyle" ) ?>
            highlightActiveLine: <?prg return GetKeyIni( , "highlightActiveLine" ) ?>, // boolean
            highlightSelectedWord: <?prg return GetKeyIni( , "highlightSelectedWord" ) ?>, // boolean
            readOnly: <?prg return GetKeyIni( , "readOnly" ) ?>, // boolean: true if read only
            cursorStyle: <?prg return GetKeyIni( , "cursorStyle" ) ?>, // "ace"|"slim"|"smooth"|"wide"
            mergeUndoDeltas: <?prg return GetKeyIni( , "mergeUndoDeltas" ) ?>, // false|true|"always"
            behavioursEnabled: <?prg return GetKeyIni( , "behavioursEnabled" ) ?>, // boolean: true if enable custom behaviours
            wrapBehavioursEnabled: <?prg return GetKeyIni( , "wrapBehavioursEnabled" ) ?>, // boolean
            autoScrollEditorIntoView: <?prg return GetKeyIni( , "autoScrollEditorIntoView" ) ?>, // boolean: this is needed if editor is inside scrollable page
            keyboardHandler: <?prg return GetKeyIni( , "keyboardHandler" ) ?>, // function: handle custom keyboard events

            // renderer options
            animatedScroll: <?prg return GetKeyIni( , "animatedScroll" ) ?>, // boolean: true if scroll should be animated
            displayIndentGuides: <?prg return GetKeyIni( , "displayIndentGuides" ) ?>, // boolean: true if the indent should be shown. See 'showInvisibles'
            showInvisibles: <?prg return GetKeyIni( , "showInvisibles" ) ?>, // boolean -> displayIndentGuides: true if show the invisible tabs/spaces in indents
            showPrintMargin: <?prg return GetKeyIni( , "showPrintMargin" ) ?>, // boolean: true if show the vertical print margin
            printMarginColumn: <?prg return GetKeyIni( , "printMarginColumn" ) ?>, // number: number of columns for vertical print margin
            printMargin: <?prg return GetKeyIni( , "printMargin" ) ?>, // boolean | number: showPrintMargin | printMarginColumn
            showGutter: <?prg return GetKeyIni( , "showGutter" ) ?>, // boolean: true if show line gutter
            fadeFoldWidgets: <?prg return GetKeyIni( , "fadeFoldWidgets" ) ?>, // boolean: true if the fold lines should be faded
            showFoldWidgets: <?prg return GetKeyIni( , "showFoldWidgets" ) ?>, // boolean: true if the fold lines should be shown ?
            showLineNumbers: <?prg return GetKeyIni( , "showLineNumbers" ) ?>,
            highlightGutterLine: <?prg return GetKeyIni( , "highlightGutterLine" ) ?>, // boolean: true if the gutter line should be highlighted
            hScrollBarAlwaysVisible: <?prg return GetKeyIni( , "hScrollBarAlwaysVisible" ) ?>, // boolean: true if the horizontal scroll bar should be shown regardless
            vScrollBarAlwaysVisible: <?prg return GetKeyIni( , "vScrollBarAlwaysVisible" ) ?>, // boolean: true if the vertical scroll bar should be shown regardless
            fontSize: <?prg return GetKeyIni( , "fontSize" ) ?>, // number | string: set the font size to this many pixels
            fontFamily: <?prg return GetKeyIni( , "fontFamily" ) ?>, //"Lucida Console", //undefined, // - string: set the font-family css value
            maxLines: <?prg return GetKeyIni( , "maxLines" ) ?>, // 26 - number: set the maximum lines possible. This will make the editor height changes
            minLines: <?prg return GetKeyIni( , "minLines" ) ?>, // 26 - number: set the minimum lines possible. This will make the editor height changes
            maxPixelHeight: <?prg return GetKeyIni( , "maxPixelHeight" ) ?>, // number -> maxLines: set the maximum height in pixel, when 'maxLines' is defined. 
            scrollPastEnd: <?prg return GetKeyIni( , "scrollPastEnd" ) ?>, // number -> !maxLines: if positive, user can scroll pass the last line and go n * editorHeight more distance 
            fixedWidthGutter: <?prg return GetKeyIni( , "fixedWidthGutter" ) ?>, // boolean: true if the gutter should be fixed width
            theme: <?prg return GetKeyIni( , "theme" ) ?>,   // theme string from ace/theme or custom?

            // mouseHandler options
            scrollSpeed: <?prg return GetKeyIni( , "scrollSpeed" ) ?>, // number: the scroll speed index
            dragDelay: <?prg return GetKeyIni( , "dragDelay" ) ?>, // number: the drag delay before drag starts. it's 150ms for mac by default 
            dragEnabled: <?prg return GetKeyIni( , "dragEnabled" ) ?>, // boolean: enable dragging
            //focusTimout: <?prg return GetKeyIni( , "focusTimout" ) ?>, // number: the focus delay before focus starts.
            tooltipFollowsMouse: <?prg return GetKeyIni( , "tooltipFollowsMouse" ) ?>, // boolean: true if the gutter tooltip should follow mouse

            // session options
            firstLineNumber: <?prg return GetKeyIni( , "firstLineNumber" ) ?>, // number: the line number in first line
            overwrite: <?prg return GetKeyIni( , "overwrite" ) ?>, // boolean
            newLineMode: <?prg return GetKeyIni( , "newLineMode" ) ?>, // "auto" | "unix" | "windows"
            useWorker: <?prg return GetKeyIni( , "useWorker" ) ?>, // boolean: true if use web worker for loading scripts
            useSoftTabs: <?prg return GetKeyIni( , "useSoftTabs" ) ?>, // boolean: true if we want to use spaces than tabs
            tabSize: <?prg return GetKeyIni( , "tabSize" ) ?>, // number
            wrap: <?prg return GetKeyIni( , "wrap" ) ?>, // boolean | string | number: true/'free' means wrap instead of horizontal scroll, false/'off' means horizontal scroll instead of wrap, and number means number of column before wrap. -1 means wrap at print margin
            indentedSoftWrap: <?prg return GetKeyIni( , "indentedSoftWrap" ) ?>, // boolean
            foldStyle: <?prg return GetKeyIni( , "foldStyle" ) ?>, // enum: 'manual'/'markbegin'/'markbeginend'.
            mode: <?prg return GetKeyIni( , "mode" ) ?>, // string: path to language mode 
            enableMultiselect: <?prg return GetKeyIni( , "enableMultiselect" ) ?>,
            // Others
            enableEmmet: <?prg return GetKeyIni( , "enableEmmet" ) ?>,
            enableBasicAutocompletion: <?prg return GetKeyIni( , "enableBasicAutocompletion" ) ?>,
            enableLiveAutocompletion: <?prg return GetKeyIni( , "enableLiveAutocompletion" ) ?>,
            enableSnippets: <?prg return GetKeyIni( , "enableSnippets" ) ?>,
            //spellcheck: <?prg return GetKeyIni( , "spellcheck" ) ?>,
            //useElasticTabstops: <?prg return GetKeyIni( , "useElasticTabstops" ) ?> 
         });

         editor.commands.addCommand({
             name: "showKeyboardShortcuts",
             bindKey: {win: "Ctrl-Alt-h", mac: "Command-Alt-h"},
             exec: function(editor) {
                 ace.config.loadModule("ace/ext/keybinding_menu", function(module) {
                     module.init(editor);
                     editor.showKeyboardShortcuts()
                   })
               }
            });
         editor.commands.addCommand({
             name: 'Help',
             bindKey: {win: 'F1',  mac: 'F1'},
             exec: function(editor) {
                $('#about').modal();
                },
              readOnly: true // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'Clear',
             bindKey: {win: 'F5',  mac: 'F5'},
             exec: function(editor) {
                Clear();
                },
              readOnly: false // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'GoTo',
             bindKey: {win: 'F6',  mac: 'F6'},
             exec: function(editor) {
                 $('#gotoline').modal();
                },
              readOnly: true // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'ClearResult',
             bindKey: {win: 'F7',  mac: 'F7'},
             exec: function(editor) {
                Clear( true );
                },
              readOnly: false // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'Run',
             bindKey: {win: 'F9',  mac: 'F9'},
             exec: function(editor) {
                //Run();
                editor_run();
                },
              readOnly: true // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'Save',
             bindKey: {win: 'Ctrl-S',  mac: 'Command-S'},
             exec: function(editor) {
                Download();
                },
              readOnly: true // false if this command should not apply in readOnly mode
            });
         editor.commands.addCommand({
             name: 'SaveAs',
             bindKey: {win: 'Ctrl-Q',  mac: 'Command-Q'},
             exec: function(editor) {
                $('#saveas').modal();
                },
              readOnly: true // false if this command should not apply in readOnly mode
            });

         editor.session.on('change', function( e ) {
            if ( editor.getValue() ) {
               textos[ ctab.toUpperCase() ] = editor.getValue();
            }
          } );

         function Search() {
            editor.find( "o", {
                         backwards: false,
                         wrap: true,
                         caseSensitive: false,
                         wholeWord: false,
                         skipCurrent: false,
                         preventScroll: true,
                         range: null,
                         regExp: false
                         } );
         }

         function GotoLine() {
            var nline = document.getElementById("goline").value;
            var ncol  = document.getElementById("gocol").value;
            if ( nline ) {
               if ( !ncol ) {
                  ncol = 1;
               }
               editor.scrollToLine( nline, true, true, function () {});
               editor.gotoLine( nline, ncol, true);
            }
         }

         function SaveFileAs() {
            var fil = document.getElementById("filesave").value;
            var content = editor.getValue();
            var pom = document.createElement('a');
            pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + 
                 encodeURIComponent( content.replace( /\\n/g, "\\r\\n" ) ) );
            pom.setAttribute('download', fil );

            if (document.createEvent) {
                var event = document.createEvent('MouseEvents');
                event.initEvent('click', true, true);
                pom.dispatchEvent(event);
            }
            else {
                pom.click();
            }
         }

         function Download() {
            var filename = ctab.trim();
            var content = editor.getValue();
            var pom = document.createElement('a');
            pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + 
                 encodeURIComponent( content.replace( /\\n/g, "\\r\\n" ) ) );
            pom.setAttribute('download', filename);

            if (document.createEvent) {
                var event = document.createEvent('MouseEvents');
                event.initEvent('click', true, true);
                pom.dispatchEvent(event);
            }
            else {
                pom.click();
            }
         }

         function Clear( onlyresult ) {
            var text = '';
            editor.setValue( text,1 );
            //Run();
            editor_run();
            selectfile.value = '';
            //$(".nav-tabs li").children('a').last().focus();
            if ( !onlyresult ) {
               textos[ ctab.toUpperCase() ] = text;
            }
            else {
               editor.setValue( textos[ ctab.toUpperCase() ], 1 );
            }
            //editor.focus();
         }

        function addtab( name ) {
            var nextTab = $('#tabs').children().length+1;
            // He quitado el class="active"
            ctab = name.trim().toUpperCase();
            $('<li id="tab'+nextTab+'"'+ '><a data-toggle="tab" href="#row1" role="tab" title=' + 
               "<?prg return cToolTab ?>" + ">" + '</a><span>x</span></li>').appendTo('#tabs');
          	//$('<div class="row" id="row1'+nextTab+'"'+'>'+$('#row1')+'</div>').appendTo('.tab-content');
            $('<div class="row" id="row1">'+'</div>').appendTo('.tab-content');
            $('#tabs a:last').text( ctab );
            $('#tabs a:last').click();
        }

         function openFile(event) {
            var text = '';
            editor.setValue( text );
            //Run();
            editor_run();
            var input = event.target;
            var reader = new FileReader();
            reader.readAsText( input.files[0] );
            reader.onload = function(){
            var text = reader.result;
            if ( input.files[0] ) {
               if ( ctab.trim().toUpperCase() != "NONAME1.PRG" ) { //& !editor.getValue() &
                  addtab( input.files[0].name );
                  $('#tabs a:last').title = $("#selectfile").value ;
               }
               else {
                  ctab = input.files[0].name.trim().toUpperCase();
                  $('#tabs a:first').text( ctab );
                  $('#tabs a:first').title = $("#selectfile").value ;
                  $('#tabs a:first').focus();
               }
               //console.log( document.getElementById("selectfile").value );
               editor.setValue( text, -1 );
               var mode = autoImplementedMode( ctab.toLowerCase() );
               //var mode = getModeByFileExtension( ctab );
               if ( mode ) {
                  editor.getSession().setMode(mode);
               }
               textos[ ctab.toUpperCase() ] = text;
            }
           }
           //editor.focus();
         }

         function getFile( url ){
            var request = new XMLHttpRequest();
            console.log( url );
            request.open( 'GET', url, true);
            //request.setRequestHeader( "Access-Control-Allow-Headers", "Origin, Methods, Content-Type, X-Requested-With, Accept" );
            //request.setRequestHeader("Access-Control-Request-Headers", "*" );
            request.setRequestHeader("Access-Control-Allow-Methods", "GET,OPTIONS");
            //request.setRequestHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
            request.setRequestHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Origin, content-type, accept, authorization" );
            request.setRequestHeader( 'Access-Control-Allow-Origin', 'localhost' );
            //request.setRequestHeader( 'Access-Control-Allow-Methods', 'GET, POST, PUT, HEAD' );
            request.timeout = 10000;
            request.onload = function () {
             //   window.alert("Loading");
             //   window.alert(request.responseText);
             };
            request.onsuccess = function() {
             //   window.alert("Success!");
             //   window.alert(request.responseText);
             };
            request.onerror = function() {
             //   window.alert("Error!");
             //   window.alert(request.responseText);
             };
            request.onprogress = function() {
             //   window.alert("Progress");
             //   window.alert(request.responseText);
             };
            request.send(null);
            console.log( request.readyState );
            console.log( request.responseText );
            request.onreadystatechange = function () {
               if ( request.readyState === 4 && request.status === 200 ) {
                  var type = request.getResponseHeader('Content-Type');
                  if (type.indexOf("text") !== -1) {
                     return request.responseText;
                     }
                  }
               }
         }

         function autoImplementedMode( filename ){
             var ext = filename.split('.').pop().toLowerCase();
             var prefix = "ace/mode/";
             if(!ext){
                 return prefix + "text";
             }
             switch (ext) {
                 case "c":
                    return prefix + "c_cpp";
                 case "ccp":
                    return prefix + "c_cpp";
                 case "cxx":
                    return prefix + "c_cpp";
                 case "h":
                    return prefix + "c_cpp";
                 case "prg":
                    return prefix + "c_cpp";
                 case "ch":
                    return prefix + "c_cpp";
                 case "rc":
                    return prefix + "c_cpp";
                 case "htm":
                    return prefix + "html";
                 case "html":
                    return prefix + "html";
                 case "tpl":
                    return prefix + "html";
                 case "view":
                    return prefix + "html";
                 case "js":
                    return prefix + "javascript";
                 case "css":
                    return prefix + "css";
                 case "cs":
                    return prefix + "csharp";
                 case "php":
                    return prefix + "php";
                 case "rb":
                    return prefix + "ruby";
                 case "ini":
                    return prefix + "ini";
                 case "mysql":
                    return prefix + "mysql";
                 case "sql":
                    return prefix + "sql";
                 case "sqlserver":
                    return prefix + "sqlserver";
                 case "pgsql":
                    return prefix + "pgsql";
                 case "xml":
                    return prefix + "xml";
                 case "json":
                    return prefix + "json";
                    //indent for levels
                    //editor.setValue(JSON.stringify(jsonDoc, null, '\t'));
                 case "php":
                    return prefix + "php";
                 case "inc":
                    return prefix + "inc";
                 case "php3":
                    return prefix + "php";
                 case "php4":
                    return prefix + "php";
                 case "php5":
                    return prefix + "php";
                 case "phps":
                    return prefix + "php";
                 case "blade.php":
                    return prefix + "php_laravel_blade";
                 case "py":
                    return prefix + "python";
                 case "txt":
                    return prefix + "text";
             }
         }

         function getModeByFileExtension(path){
            var modelist = ace.require("ace/ext/modelist");
            return modelist.getModeForPath(path).mode;
         }

         function cFileNoPathLocal( cname ) {
            var name = cname.split('\').pop();
         }

        $(document).ready(function () {
           //editor.addEventListener( aEventName, aCallback);
           //editor.resize();

           $( ".nav-tabs" ).on( "click", "a", function(e){
              //var current = document.getElementsByClassName(".nav-tabs")
              //console.log( current );
              if ( !ctab ) {
                 ctab = "<?prg return cTabFile ?>"
              }
              var curl = "<?prg return cToolTab ?>"
              if ( ctab.toUpperCase() != "NONAME1.PRG" & !editor.getValue() &
                   ( curl.indexOf("http://") > -1 | curl.indexOf("https://") > -1 ) ) {
                 getFile( curl );
              }
              e.preventDefault();
              if ( ctab.toUpperCase() != $(this).text().toUpperCase() ) {
                 ctab = $(this).text().toUpperCase();
                 $(this).text( ctab.trim().toUpperCase() );
                 editor.setValue('',1);
                 //Run();
                 editor_run();
                 editor.setValue( textos[ ctab.trim().toUpperCase() ], -1 );
                 var mode = autoImplementedMode( ctab.trim().toLowerCase() );
                 if ( mode ) {
                    editor.getSession().setMode(mode);
                    }
                 }
              $(this).show();
              $(this).focus();
              //editor.focus();
           })
           .on("click", "span", function () {
              var anchor = $(this).siblings('a');
              var nextTab = $('#tabs').children().length;
              textos.splice( anchor.text(), 1);
              editor.setValue( '', -1 );
              selectfile.value = '';
              if ( nextTab > 1 ) {
                 //$(anchor.attr('href')).remove();
                 $(this).parent().remove();
                 ctab = $('#tabs a:last').text().toUpperCase();
                 //Run();
                 editor_run();
                 editor.setValue( textos[ ctab.trim().toUpperCase() ], -1 );
                }
              else {
                 ctab = "NONAME1.PRG";
                 $('#tabs a:last').text( ctab );
                 //Run();
                 editor_run();
                 textos[ ctab.trim().toUpperCase() ] = editor.getValue();
                }
                var mode = autoImplementedMode( ctab.toLowerCase());
                if ( mode ) {
                   editor.getSession().setMode(mode);
                   }
                $('#tabs a:last').click();
                //$(".nav-tabs li").children('a').last().focus();
            });

           $(".nav-tabs li").children('a').last().click();
           //$(".nav-tabs li").children('a').last().focus();

           $("#row1").splitter( null, npossplitter );  //0.8
        });

        function init_window() {
           //if ( confirm("Close Window?") )  {
              window.open(location,'_self').close();
           //}
        }

        function editor_run() {
          var ext = ctab.split('.').pop().toLowerCase();
          //console.log( ext );
          if ( ext == 'prg' | ext == 'hrb' ) {
             Run();
            }
          else {
             if ( ext == "html" | ext == "htm" | ext == "view" | ext == "tpl" ) {
                document.getElementById("result").innerHTML = editor.getValue();
               }
          }
          editor.focus();
        }

        function openfileconfig() {
            addtab( "XCLOUD.INI" );
            textos[ ctab.trim().toUpperCase() ] = <?prg return GetTextIni( cIni ) ?>;
            textos[ ctab.trim().toUpperCase() ] = textos[ ctab.trim().toUpperCase() ].replace( /\\|/g, "\\r\\n" );
            editor.setValue( textos[ ctab.trim().toUpperCase() ], -1 );
            editor.focus();
        }

        function ToggleResult() {
          var x = document.getElementById( "result" );
          if ( x.style.display === "none" ) {
             x.style.display = "block";
           } else {
             x.style.display = "none";
             //$("#row1").splitter().Resize();
             var y = document.getElementById( "vsplitbar" );
             //console.log( y );
           }
        }

//----------------------------------------------------------------------------//
// jQuery.splitter.js - two-pane splitter window plugin
// 
// version 1.51 (2009/01/09) 
// 
// Dual licensed under the MIT and GPL licenses: 
//   https://www.opensource.org/licenses/mit-license.php 
//   http://www.gnu.org/licenses/gpl.html 
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//
// The splitter() plugin implements a two-pane resizable splitter window.
// The selected elements in the jQuery object are converted to a splitter;
// each selected element should have two child elements, used for the panes
// of the splitter. The plugin adds a third child element for the splitbar.
// 
// For more details see: http://methvin.com/splitter/
//
//
// @example $('#MySplitter').splitter();
// @desc Create a vertical splitter with default settings 
//
// @example $('#MySplitter').splitter({type: 'h', accessKey: 'M'});
// @desc Create a horizontal splitter resizable via Alt+Shift+M
//
// @name splitter
// @type jQuery
// @param Object options Options for the splitter (not required)
// @cat Plugins/Splitter
// @return jQuery
// @author Dave Methvin (dave.methvin@gmail.com)
//----------------------------------------------------------------------------//

      ; (function ($) {

      $.fn.splitter = function (args,npos) {
         args = args || {};
         npos = npos || 0.52 ;
        
         return this.each(function () {
            var zombie;		// left-behind splitbar for outline resizes

            function startSplitMouse(evt) {
                if (opts.outline)
                    zombie = zombie || bar.clone(false).insertAfter(A);
                panes.css("-webkit-user-select", "none");	// Safari selects A/B text on a move
                bar.addClass(opts.activeClass);
                A._posSplit = A[0][opts.pxSplit] - evt[opts.eventPos];
                $(document)
                    .bind("mousemove", doSplitMouse)
                    .bind("mouseup", endSplitMouse);
            }
            function doSplitMouse(evt) {
                var newPos = A._posSplit + evt[opts.eventPos];
                if (opts.outline) {
                    newPos = Math.max(0, Math.min(newPos, splitter._DA - bar._DA));
                    bar.css(opts.origin, newPos);
                } else
                    resplit(newPos);
            }
            function endSplitMouse(evt) {
                bar.removeClass(opts.activeClass);
                var newPos = A._posSplit + evt[opts.eventPos];
                if (opts.outline) {
                    zombie.remove(); zombie = null;
                    resplit(newPos);
                }
                panes.css("-webkit-user-select", "text");	// let Safari select text again
                $(document)
                    .unbind("mousemove", doSplitMouse)
                    .unbind("mouseup", endSplitMouse);
            }
            function resplit(newPos) {
                // Constrain new splitbar position to fit pane size limits
                newPos = Math.max(A._min, splitter._DA - B._max,
                        Math.min(newPos, A._max, splitter._DA - bar._DA - B._min));
                // Resize/position the two panes
                bar._DA = bar[0][opts.pxSplit];		// bar size may change during dock
                bar.css(opts.origin, newPos).css(opts.fixed, splitter._DF);
                A.css(opts.origin, 0).css(opts.split, newPos).css(opts.fixed, splitter._DF);
                B.css(opts.origin, newPos + bar._DA)
                    .css(opts.split, splitter._DA - bar._DA - newPos).css(opts.fixed, splitter._DF);
                // IE fires resize for us; all others pay cash
                if (!$.browser.msie)
                    panes.trigger("resize");
            }
            function dimSum(jq, dims) {
                // Opera returns -1 for missing min/max width, turn into 0
                var sum = 0;
                for (var i = 1; i < arguments.length; i++)
                    sum += Math.max(parseInt(jq.css(arguments[i])) || 0, 0);
                return sum;
            }

            // Determine settings based on incoming opts, element classes, and defaults
            var vh = (args.splitHorizontal ? 'h' : args.splitVertical ? 'v' : args.type) || 'v';
            var opts = $.extend({
                activeClass: 'active',	// class name for active splitter
                pxPerKey: 8,			// splitter px moved per keypress
                tabIndex: 0,			// tab order indicator
                accessKey: ''			// accessKey for splitbar
            }, {
                v: {					// Vertical splitters:
                    keyLeft: 39, keyRight: 37, cursor: "e-resize",
                    splitbarClass: "vsplitbar", outlineClass: "voutline",
                    type: 'v', eventPos: "pageX", origin: "left",
                    split: "width", pxSplit: "offsetWidth", side1: "Left", side2: "Right",
                    fixed: "height", pxFixed: "offsetHeight", side3: "Top", side4: "Bottom"
                },
                h: {					// Horizontal splitters:
                    keyTop: 40, keyBottom: 38, cursor: "n-resize",
                    splitbarClass: "hsplitbar", outlineClass: "houtline",
                    type: 'h', eventPos: "pageY", origin: "top",
                    split: "height", pxSplit: "offsetHeight", side1: "Top", side2: "Bottom",
                    fixed: "width", pxFixed: "offsetWidth", side3: "Left", side4: "Right"
                }
            }[vh], args);

            // Create jQuery object closures for splitter and both panes
            var splitter = $(this).css({ position: "relative" });
            var panes = $(">*", splitter[0]).css({
                position: "absolute", 			// positioned inside splitter container
                "z-index": "1",					// splitbar is positioned above
                "-moz-outline-style": "none"	// don't show dotted outline
            });
            var A = $(panes[0]);		// left  or top
            var B = $(panes[1]);		// right or bottom
            
            // Focuser element, provides keyboard support; title is shown by Opera accessKeys
            $.extend({
                  browser : {
                      opera : /opera/.test(navigator.userAgent.toUpperCase())
                }
            }) 
            //$.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());
            //$.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
            
            //$.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
            var focuser = $('<a href="javascript:void(0)"></a>')
                .attr({ accessKey: opts.accessKey, tabIndex: opts.tabIndex, title: opts.splitbarClass })
                .bind($.browser.opera ? "click" : "focus", function () { this.focus(); bar.addClass(opts.activeClass) })
                .bind("keydown", function (e) {
                    var key = e.which || e.keyCode;
                    var dir = key == opts["key" + opts.side1] ? 1 : key == opts["key" + opts.side2] ? -1 : 0;
                    if (dir)
                        resplit(A[0][opts.pxSplit] + dir * opts.pxPerKey, false);
                })
                .bind("blur", function () { bar.removeClass(opts.activeClass) });

            // Splitbar element, can be already in the doc or we create one
            var bar = $(panes[2] || '<div></div>')
                .insertAfter(A).css("z-index", "100").append(focuser)
                .attr({ "class": opts.splitbarClass, unselectable: "on" })
                .css({
                    position: "absolute", "user-select": "none", "-webkit-user-select": "none",
                    "-khtml-user-select": "none", "-moz-user-select": "none"
                })
                .bind("mousedown", startSplitMouse);
            // Use our cursor unless the style specifies a non-default cursor
            if (/^(auto|default|)$/.test(bar.css("cursor")))
                bar.css("cursor", opts.cursor);

            // Cache several dimensions for speed, rather than re-querying constantly
            bar._DA = bar[0][opts.pxSplit];
            splitter._PBF = $.boxModel ? dimSum(splitter, "border" + opts.side3 + "Width", "border" + opts.side4 + "Width") : 0;
            splitter._PBA = $.boxModel ? dimSum(splitter, "border" + opts.side1 + "Width", "border" + opts.side2 + "Width") : 0;
            A._pane = opts.side1;
            B._pane = opts.side2;
            $.each([A, B], function () {
                this._min = opts["min" + this._pane] || dimSum(this, "min-" + opts.split);
                this._max = opts["max" + this._pane] || dimSum(this, "max-" + opts.split) || 9999;
                this._init = opts["size" + this._pane] === true ?
                    parseInt($.curCSS(this[0], opts.split)) : opts["size" + this._pane];
            });

            // Determine initial position, get from cookie if specified
            var initPos = A._init;
            if (!isNaN(B._init))	// recalc initial B size as an offset from the top or left side
                initPos = splitter[0][opts.pxSplit] - splitter._PBA - B._init - bar._DA;
            if (opts.cookie) {
                if (!$.cookie)
                    alert('jQuery.splitter(): jQuery cookie plugin required');
                var ckpos = parseInt($.cookie(opts.cookie));
                if (!isNaN(ckpos))
                    initPos = ckpos;
                $(window).bind("unload", function () {
                    var state = String(bar.css(opts.origin));	// current location of splitbar
                    $.cookie(opts.cookie, state, {
                        expires: opts.cookieExpires || 365,
                        path: opts.cookiePath || document.location.pathname
                    });
                });
            }
            if (isNaN(initPos))	// King Solomon's algorithm
                initPos = Math.round(npos*(splitter[0][opts.pxSplit] - splitter._PBA - bar._DA) );

            // Resize event propagation and splitter sizing
            if (opts.anchorToWindow) {
                // Account for margin or border on the splitter container and enforce min height
                splitter._hadjust = dimSum(splitter, "borderTopWidth", "borderBottomWidth", "marginBottom");
                splitter._hmin = Math.max(dimSum(splitter, "minHeight"), 20);
                $(window).bind("resize", function () {
                    var top = splitter.offset().top;
                    var wh = $(window).height();
                    splitter.css("height", Math.max(wh - top - splitter._hadjust, splitter._hmin) + "px");
                    if (!$.browser.msie) splitter.trigger("resize");
                }).trigger("resize");
            }
            else if (opts.resizeToWidth && !$.browser.msie)
                $(window).bind("resize", function () {
                    splitter.trigger("resize");
                });

            // Resize event handler; triggered immediately to set initial position
            splitter.bind("resize", function (e, size) {
                // Custom events bubble in jQuery 1.3; don't get into a Yo Dawg
                if (e.target != this) return;
                // Determine new width/height of splitter container
                splitter._DF = splitter[0][opts.pxFixed] - splitter._PBF;
                splitter._DA = splitter[0][opts.pxSplit] - splitter._PBA;
                // Bail if splitter isn't visible or content isn't there yet
                if (splitter._DF <= 0 || splitter._DA <= 0) return;
                // Re-divvy the adjustable dimension; maintain size of the preferred pane
                resplit(!isNaN(size) ? size : (!(opts.sizeRight || opts.sizeBottom) ? A[0][opts.pxSplit] :
                    splitter._DA - B[0][opts.pxSplit] - bar._DA));
            }).trigger("resize", [initPos]);
        });
      };
      })(jQuery);

      </script>

   </body>
   </html>
   ENDTEXT

return nil

//----------------------------------------------------------------------------//

Function GetTextInitial()

   local cTextIni

   TEXT TO VAR cTextIni
function Main()
   ? "<h1>" + "Hello world" + "</h1>"
return nil
   ENDTEXT

return cTextIni

//----------------------------------------------------------------------------//

Function GetText()
return cText

//----------------------------------------------------------------------------//

Function GetFileIni()
return cIni

//----------------------------------------------------------------------------//

Function GetTextIni( cFileIni )

   local cText    := hb_Memoread( cFileIni )
   local nLines   := Len( hb_aTokens( cText, chr( 10 ) ) )
   local cResult  := ""
   local x
   For x = 1 to nLines
       cResult    += '"' + AllTrim( MemoLine( cText, 120, x ) ) + ;
                     if( x < nLines, '|" + ', '"' )
   Next x
return cResult

//----------------------------------------------------------------------------//

Function GethIni()
return hIni

//----------------------------------------------------------------------------//

Function GetKeyIni( cSect, cKey )

   local uVal   := ""
   hb_defaultValue( cSect, "EDITOR" )    // At moment not used
   if !Empty( hIni ) .and. !Empty( cKey )
      if hb_hHaskey( hIni, cKey )
         uVal   := hIni[ cKey ]
      endif
   endif

Return uVal

//----------------------------------------------------------------------------//

Function ReadConfig( cFileIni )

   local hIniFile
   local hSection
   local aText    := {}
   local x
   local cEntry   := ""
   local nPos
   local cText    := Memoread( cFileIni )

   if !Empty( cText )
      aText     := hb_aTokens( cText, Chr( 10 ) )
      hIniFile  := hb_Hash()

      For x := 1 TO Len( aText )
         cEntry := if( Left( aText[ x ], 1 ) == ' ', Ltrim( aText[ x ] ), aText[ x ] )
         if !( Left( cEntry, 1 ) $ ";#" )
            cEntry := Trim( if( Right( cEntry, 1 ) == Chr( 13 ), ;
                                Left( cEntry, Len( cEntry ) - 1 ), cEntry ) )
            if !Empty( cEntry )
               if Left( cEntry, 1 ) == '[' .and. Right( cEntry, 1 ) == ']'
                  //hSection := hb_Hash( cEntry, hIniFile[ Substr( cEntry, 2, Len( cEntry ) - 2 ) ] )
               else
                  if ( nPos := At( '=', cEntry ) ) > 0
                     hIniFile[ Trim( Left( cEntry, nPos - 1 ) ) ] := LTrim( Substr( cEntry, nPos + 1 ) )
                  endif
               endif
            endif
         endif
      Next x
   endif

Return hIniFile

//----------------------------------------------------------------------------//

Function ConfigRead( cFileIni )

   local cText    := "[EDITOR]" + CRLF
   local cPath    := AP_GetEnv( "DOCUMENT_ROOT" ) + "\modharbour_examples\" 
   local hIniFile
   if Empty( At( "\", cFileIni ) ) .and. Empty( At( "/", cFileIni ) )
      if ( hb_ps() == "/" )
         cPath := StrTran( cPath, "\", hb_ps() )
      endif
   else
      cPath    := ""
   endif
   hb_defaultValue( cFileIni, "xcloud.ini" )
//#ifdef __PLATFORM__UNIX
   //cFileIni := '/' + Curdir() + '/' + cFileIni
   //__Run( "chmod a+x ...." )
//#else
   //cFileIni := hb_curDrive() + ":\" + Curdir() + '\' + cFileIni
//#endif
   cFileIni    := cPath + cFileIni
   if !File( cFileIni )
      cText    += "selectionStyle='line'" + CRLF
      cText    += "highlightActiveLine=true" + CRLF
      cText    += "highlightSelectedWord=true" + CRLF
      cText    += "readOnly=false" + CRLF
      cText    += "cursorStyle='ace'" + CRLF
      cText    += "mergeUndoDeltas=true" + CRLF
      cText    += "behavioursEnabled=true" + CRLF
      cText    += "wrapBehavioursEnabled=true" + CRLF
      cText    += "autoScrollEditorIntoView=undefined" + CRLF
      cText    += "keyboardHandler=null" + CRLF
      cText    += "animatedScroll=false" + CRLF
      cText    += "displayIndentGuides=false" + CRLF
      cText    += "showInvisibles=false" + CRLF
      cText    += "showPrintMargin=true" + CRLF
      cText    += "printMarginColumn=80" + CRLF
      cText    += "printMargin=undefined" + CRLF
      cText    += "showGutter=true" + CRLF
      cText    += "fadeFoldWidgets=false" + CRLF
      cText    += "showFoldWidgets=true" + CRLF
      cText    += "showLineNumbers=true" + CRLF
      cText    += "highlightGutterLine=false" + CRLF
      cText    += "hScrollBarAlwaysVisible=false" + CRLF
      cText    += "vScrollBarAlwaysVisible=false" + CRLF
      cText    += "fontSize=16" + CRLF
      cText    += "fontFamily='Liberation Mono'" + CRLF
      cText    += "maxLines=undefined" + CRLF
      cText    += "minLines=undefined" + CRLF
      cText    += "maxPixelHeight=0" + CRLF
      cText    += "scrollPastEnd=0" + CRLF
      cText    += "fixedWidthGutter=false" + CRLF
      cText    += "theme='ace/theme/cobalt'" + CRLF
      cText    += "scrollSpeed=2" + CRLF
      cText    += "dragDelay=0" + CRLF
      cText    += "dragEnabled=true" + CRLF
      cText    += "tooltipFollowsMouse=true" + CRLF
      cText    += "firstLineNumber=1" + CRLF
      cText    += "overwrite=false" + CRLF
      cText    += "newLineMode='auto'" + CRLF
      cText    += "useWorker=true" + CRLF
      cText    += "useSoftTabs=true" + CRLF
      cText    += "tabSize=3" + CRLF
      cText    += "wrap=false" + CRLF
      cText    += "indentedSoftWrap=true" + CRLF
      cText    += "foldStyle='markbegin'" + CRLF
      cText    += "mode='ace/mode/c_cpp'" + CRLF
      cText    += "enableMultiselect=true" + CRLF
      cText    += "enableEmmet=true" + CRLF
      cText    += "enableBasicAutocompletion=false" + CRLF
      cText    += "enableLiveAutocompletion=false" + CRLF
      cText    += "enableSnippets=false" + CRLF
      cText    += "spellcheck=true" + CRLF
      cText    += "useElasticTabstops=false"

      MemoWrit( cFileIni, cText )
   endif
   hIniFile   := ReadConfig( cFileIni )

Return hIniFile

//----------------------------------------------------------------------------//

function FHtmlEncode( cString )

  local nI, cI, cRet := ""

  for nI := 1 to Len( cString )
     cI := SubStr( cString, nI, 1 )
     if cI == "<"
        cRet += "&lt;"
     elseif cI == ">"
        cRet += "&gt;"
     elseif cI == "&"
        cRet += "&amp;"
     elseif cI == '"'
        cRet += "&quot;"
     else
        cRet += cI
     endif
  next nI

return cRet

//----------------------------------------------------------------------------//
