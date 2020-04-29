#ifdef __PLATFORM__WINDOWS 
   #include "c:\harbour\include\hbclass.ch"
   #include "c:\harbour\include\hboo.ch"
#else
   #include "/usr/include/harbour/hbclass.ch"
   #include "/usr/include/harbour/hboo.ch"
#endif   

Static oPanels
Static aObjs
Static aClasses
Static cMemory
Static cAliasFunc
Static cFileRun

Function Main( cParam )

   if Len( hb_aParams() ) > 0
      if Empty( cParam )
         InstanceClass( HB_GETENV( 'PRGPATH' ) + '/classes.ini' )
         GetAllClasses()
         cMemory  := AP_GetEnv( "DOCUMENT_ROOT" ) + "/modharbour_samples/memory.prg" 
         //cFileRun := AP_GetEnv( "DOCUMENT_ROOT" ) + "/modharbour_samples/run.prg" 
         cFileRun := "../run.prg"
         Machine()
      else
         ? cParam
      endif
   endif

Return nil

//----------------------------------------------------------------------------//

Function Machine()

   TEMPLATE USING oPanels PARAMS aClasses, cMemory

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, shrink-to-fit=no">
   <meta name="description" content="">
   <meta name="author" content="Cristobal Navarro">
   <title>Virtual Machine Harbour</title>
   <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
   <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.0/css/all.css'>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" id="bootstrap-css">
   <link rel="stylesheet" href="css/simple-sidebar.css">
   <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

   <style>
      .list-group-item {
         background-color:475F89;
         color:#002240;
         }
      .list-group-item:focus {
         background-color:#555555;
         color:white;
         }
      .list-group-item:hover {
         background-color:#555555;
         color:white;
         }
      .navbar-expand-lg {
         background-color:#3A5159;
         color:white;
         }
      #editor { 
         position: absolute;
         top: 34px;
         right: 0;
         bottom: 0;
         left: 10px;
         width: 98.0%;
         height: 88%;
         padding-top: 0px;
         padding-left: 4px;
         padding-right: 4px;
         padding-bottom: 0px;
      }
      #result { 
         position: absolute;
         top: 34px;
         right: 0;
         bottom: 0;
         left: 10px;
         width: 96.8%;
         height: 88%;
         padding-top: 0px;
         padding-left: 4px;
         padding-right: 4px;
         padding-bottom: 0px;
      }
      #datas {
          margin:0;
          padding:0 1.5em;
          font-weight:600;
          color:#007E33;
         }
      #methods {
          margin:0;
          padding:0 1.5em;
          font-weight:600;
         }
      #functions {
          margin:0;
          padding:0 1.5em;
          font-weight:600;
         }
      .meth {
         color:#FF8800;
          }
      .data {
         color:#007E33;
          }
      .funcs {
         color:#333333;
          }
      .nav-item {
         color:blue;
      }
      .panel > panel-primary {
         overflow: auto;
         height: 100%;
         padding-top: 2px;
         padding-left: 1px;
         padding-right: 1px;
         padding-bottom: 2px;
         border: 1px;
         border-color: gainsboro;
         border-style: solid;
      }
      .panel-success {
         overflow: auto;
         height: 100%;
         padding-top: 2px;
         padding-left: 10px;
         padding-right: 10px;
         padding-bottom: 2px;
         border: 1px;
         border-color: gainsboro;
         border-style: solid;
         }
      .panel-heading {
         height: 32px;
         font-size: 0.8rem;
         color: #ffffff;
         background-color: #999999;
         padding: 6px;
         padding-left: 10px;
         }
      .panel-body {
         color: #002240;
         background-color: Ivory;
         height: 90%;
         }
      .collapse {
         -webkit-transition: margin .25s ease-out;
         -moz-transition: margin .25s ease-out;
         -o-transition: margin .25s ease-out;
         transition: margin .25s ease-out;
         }
      .row1 {
         max-height: 45.7vh;
         min-height: 45.7vh;
         }
      .row2 {
         max-height: 46.5vh;
         min-height: 46.5vh;
         }
      .col-lg-3 {
         height: 45.7vh;
         padding-top: 1px;
         padding-left: 1px;
         padding-right: 1px;
         padding-bottom: 1px;
         }
      .col-lg-7 {
         height: 46.5vh;
         padding-top: 2px;
         padding-left: 4px;
         padding-right: 6px;
         padding-bottom: 2px;
         border: 1px;
         border-color: gainsboro;
         border-style: solid;
         }
      .col-lg-5 {
         height: 46.5vh;
         padding-top: 2px;
         padding-left: 10px;
         padding-right: 10px;
         padding-bottom: 2px;
         border: 1px;
         border-color: gainsboro;
         border-style: solid;
         }
      .btn {
         border-radius: 4px;
         border: 1px;
         font-size:16px;
         background-color:#111111;
         color:white;
         }
      .btn:focus {
         border: 1px;
         background-color:#555555;
         color:white;
         }
      .btn:hover {
         border: 1px;
         background-color:#555555;
         color:white;
         }
      .navbar {
         overflow: initial;
      }
      .navbar .icon {
        color:white;
        display: none;
      }
      .nav-link {
         background-color:#111111;
         color:white;
         }
      .nav-link:focus {
         background-color:#555555;
         color:white;
         }
      .nav-link:hover {
         background-color:#555555;
         color:white;
         }
      @media screen and (max-width: 600px) {
      .navbar a:not(:first-child) {display: none;}
      .navbar a.icon {
         float: right;
         display: block;
         }
      }
      @media screen and (max-width: 600px) {
      .navbar.responsive { 
         position: relative;
      }
      .navbar.responsive a.icon {
         position: absolute;
         right: 0;
         top: 0;
         }
      .navbar.responsive a {
         float: none;
         display: block;
         text-align: left;
         }
      }
      .tree, .tree ul {
         margin:0;
         padding:0;
         list-style:none
         }
      .tree ul {
          margin-left:1em;
          position:relative
         }
      .tree ul ul {
          margin-left:.5em
         }
      .tree ul:before {
          content:"";
          display:block;
          width:0;
          position:absolute;
          top:0;
          bottom:0;
          left:0;
          border-left:1px solid
         }
      .tree li {
          margin:0;
          padding:0 1em;
          line-height:1.70em;
          font-weight:550;
          position:relative
         }
      .tree ul li:before {
          content:"";
          display:block;
          width:10px;
          height:0;
          border-top:1px solid;
          margin-top:-1px;
          position:absolute;
          top:1em;
          left:0
         }
      .tree ul li:last-child:before {
          background:#fff;
          height:auto;
          top:1em;
          bottom:0
         }
      .indicator {
          margin-right:5px;
         }
      .tree li > a:not(:active){
          color:#369;
         }
      .tree li a:active, .tree li a:focus {
          color:#e65100;
         }
      .tree li button, .tree li button:active, .tree li button:focus {
          text-decoration: none;
          color:#369;
          border:none;
          background:transparent;
          margin:0px 0px 0px 0px;
          padding:0px 0px 0px 0px;
          outline: 0;
         }
   </style>
</head>

<body>
   <div class="d-flex" id="wrapper">

    <div class="bg-light border-right" id="sidebar-wrapper">
      <div class="sidebar-heading" style="font-size:16px;height:54px;padding-top:16px;background-color:#111111;color:white;">
         <i class="fas fa-chalkboard" style="padding-right:2px"></i>
         <b>VIRTUAL MACHINE</b>
      </div>
      <div class="list-group list-group-flush">
         <a href="#" class="list-group-item list-group-item-action">All Symbols</a>
         <a href="#" class="list-group-item list-group-item-action">With Code</a>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="fas fa-th" style="font-size:14px;padding-right:6px"></i>
            Dashboard
         </a>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="fas fa-search-location" style="font-size:14px;padding-right:6px"></i>
            Search
         </a>
      </div>

      <div class="sidebar-heading" style="font-size:16px;height:40px;padding-top:8px;;background-color:#111111;color:white;">
         <i class="fas fa-chalkboard-teacher" style="padding-right:2px"></i>
         <b>ACTIONS CODE</b>
      </div>
      <div class="list-group list-group-flush">
         <a href="#" class="list-group-item list-group-item-action" onclick="editor_run(true)">
            <i class="fas fa-sync" style="font-size:14px;padding-right:6px"></i>
            Run
            </a>
         <div class="dropright">
            <a class="list-group-item list-group-item-action dropdown-toggle dropdown-toggle-split"
               href="#" id="itemDropdown1"
               role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
               <i class="fas fa-cogs" style="font-size:14px;padding-right:6px"></i>
               Editor Actions
            </a>
            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="itemDropdown1">
               <a class="dropdown-item" href="#" onclick="editor.undo()" title="[ Ctrl + Z ]">
                  <i class="fas fa-undo" style="font-size:14px;padding-right:6px"></i>
                  Undo
               </a>
               <a class="dropdown-item" href="#" onclick="editor.redo()" title="[ Ctrl + A ]">
                  <i class="fas fa-redo" style="font-size:14px;padding-right:6px"></i>
                  Redo
               </a>
               <div class="dropdown-divider"></div>
               <a class="dropdown-item dropdown-item-action" href="#" id="goto">
                  <i class="fas fa-indent" style="font-size:14px;padding-right:6px"></i>
                  Go to
               </a>
               <div class="dropdown-divider"></div>
               <a class="dropdown-item" href="#">
                  <i class="far fa-save" style="font-size:14px;padding-right:6px"></i>
                  Save As
               </a>
            </div>
         </div>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="fas fa-save" style="font-size:14px;padding-right:6px"></i>
            Save
         </a>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="fas fa-file-export" style="font-size:14px;padding-right:6px"></i>
            Open
         </a>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="far fa-file-alt" style="font-size:14px;padding-right:6px"></i>
            New
         </a>
         <a class="list-group-item list-group-item-action" href="#" onclick="Clear()">
            <i class="far fa-edit" style="font-size:14px;padding-right:6px"></i>
            Clear All
         </a>
         <a class="list-group-item list-group-item-action" href="#" onclick="Clear( true )">
            <i class="far fa-file" style="font-size:14px;padding-right:6px"></i>
            Clear Result
         </a>
         <a href="#" class="list-group-item list-group-item-action">
            <i class="far fa-calendar" style="font-size:14px;padding-right:6px"></i>
            Run Extern
         </a>
         <a href="#" class="list-group-item list-group-item-action" onclick="editor_run()">
            <i class="far fa-file-code" style="font-size:14px;padding-right:6px"></i>
            Run Html Code
         </a>
      </div>
    </div>

    <div id="page-content-wrapper">
      <nav class="navbar navbar-expand-lg border-bottom"
          id="myTopnav" style="height:54px;background-color:#111111;color:white;">
         <a href="javascript:void(0);" class="icon" onclick="SetResponsive()">
          <i class="fa fa-bars"></i>
         </a>
         <button class="btn btn-default btn-md" type="button" id="menu-toggle" title="[ ALT + A ]"
            data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
            aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-angle-double-left"></i> MENU PANELS
         </button>
         <a class="navbar-brand" href="#"></a>
         <button class="btn btn-default btn-md" type="button" id="datos-toggle" title="[ ALT + B ]"
            data-toggle="collapse" data-target="#rowDatos" aria-expanded="false"
            aria-controls="rowDatos">            
            <i class="fas fa-angle-double-down"></i> CLASSES PANELS
         </button>
         <a class="navbar-brand" href="#"></a>
         <button class="btn btn-default btn-md" type="button" id="code-toggle" title="[ ALT + C ]"
            data-toggle="collapse" data-target="#rowCodeResults" aria-expanded="false"
            aria-controls="rowCodeResults">            
            <i class="fas fa-angle-double-down"></i> CODE / RESULTS PANELS
         </button>
         
         <div class="collapse navbar-collapse" id="navbarSupportedContent">
           <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
             <li class="nav-item active">
               <a class="nav-link" href="https://fivetechsoft.github.io/mod_harbour/">
                  HOME <span class="sr-only">(current)</span>
               </a>
             </li>
             <li class="nav-item">
               <a class="nav-link" href="#" onclick="show_memory()">MEMORY </a>
             </li>
             <li class="nav-item">
               <a class="nav-link" href="https://harbour.fourtech.es/modharbour_samples/sandbox.prg">SANDBOX </a>
             </li>
             <li class="nav-item dropdown">
               <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                  role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  SAMPLES
               </a>
               <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                 <a class="dropdown-item" href="https://harbour.fourtech.es/modharbour_samples/blog/index.prg">
                 <i class="fas fa-landmark" style="font-size:14px;padding-right:6px"></i>
                    Blog
                 </a>
                 <a class="dropdown-item" href="https://harbour.fourtech.es/modharbour_samples/eshop/index.prg">
                    <i class="far fa-building" style="font-size:14px;padding-right:6px"></i>
                    EShop
                 </a>
                 <a class="dropdown-item" href="https://harbour.fourtech.es/modharbour_samples/genesis.prg">
                    <i class="far fa-building" style="font-size:14px;padding-right:6px"></i>
                    Genesis
                 </a>
                 <div class="dropdown-divider"></div>
                 <a class="dropdown-item" href="https://harbour.fourtech.es/modharbour_samples/apps/honey/index.prg">
                  <i class="fas fa-industry" style="font-size:14px;padding-right:6px"></i>
                    Honey
                 </a>
                 <a class="dropdown-item" href="https://harbour.fourtech.es/modharbour_samples/apps/mvc_notes/">
                  <i class="fas fa-tags" style="font-size:14px;padding-right:6px"></i>
                    Notes
                 </a>
               </div>
             </li>
           </ul>
         </div>
      </nav>

      <div class="container-fluid">
        <div class="collapse" id="rowDatos">
         <div class="row row-no-gutters row1" id="row1">
           <div class="col-lg-3">
              <div class="panel panel-success">
                   <div class="panel-heading">
                   <i class="fas fa-project-diagram" style="font-size:18px;padding-right:6px" onclick="BtnClassClick()"></i>
                       <b>CLASSES HIERARCHY</b>
                   <button class='btn-default btn-xs dropdown-toggle pull-right' id='MenuClasses'
                      data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
                      style='border:none;background-color:Transparent;'>
                      <i style='font-size:18px' class='fas'>&#xf0c9;</i>
                   </button>
                      <div class="dropdown-menu" aria-labelledby="MenuClasses">
                        <a class="dropdown-item" href="#">Create</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="#">Inherit</a>
                        <a class="dropdown-item" href="#">More</a>
                      </div>
                   </div>
                   <div class="panel-body" id="classes" scrolling="auto"
                      style="overflow-y: scroll;overflow-x: scroll;">
                      <ul id="tree1">
                         <?prg return CreateTree() ?>
                      </ul>
                   </div>
              </div>
           </div>
           <div class="col-lg-3">
               <div class="panel panel-success">
                   <div class="panel-heading">
                   <i class="far fa-list-alt" style="font-size:18px;padding-right:6px" onclick="BtnDatasClick()"></i>
                       <b>DATAS / CLASSDATAS</b>
                   </div>
                   <div class="panel-body" id="datas" scrolling="auto"
                      style="overflow-y: scroll;overflow-x: scroll;">
                   </div>
               </div>
           </div>
           <div class="col-lg-3">
               <div class="panel panel-success">
                  <div class="panel-heading">
                   <i class="fas fa-bezier-curve" style="font-size:18px;padding-right:6px" onclick="BtnMethodsClick()"></i>
                      <b>METHODS</b>
                  </div>
                  <div class="panel-body" id="methods" scrolling="auto"
                      style="overflow-y: scroll;overflow-x: scroll;"></div>
               </div>
           </div>
           <div class="col-lg-3">
               <div class="panel panel-success">
                  <div class="panel-heading">
                   <i class="fas fa-info-circle" style="font-size:18px;padding-right:6px" onclick="BtnFunctionsClick()"></i>
                     <b>FUNCTIONS / SYMBOLS</b>
                  </div>
                  <div class="panel-body" id="functions" scrolling="auto"
                      style="overflow-y: scroll;overflow-x: scroll;">
                      <?prg return GetFunctions() ?>
                  </div>
               </div>
           </div>
         </div>
        </div>
        <div class="collapse" id="rowCodeResults">
         <div class="row row-no-gutters row2" id="row2">
           <div class="col-lg-7">
               <div class="panel panel-primary" style="padding-left:6px;padding-right:1px;" onclick="BtnEditorClick()">
                   <div class="panel-heading">
                   <i class="far fa-edit" style="font-size:18px;padding-right:6px"></i>
                       <b>CODE</b>
                   </div>
                   <div class="panel-body">
                        <div id="editor">CLASS TTest
                        
ENDCLASS                </div>
                   </div>
               </div>
           </div>
           <div class="col-lg-5">
               <div class="panel panel-primary">
                  <div class="panel-heading">
                  <i class="fa fa-eye" style="font-size:18px;padding-right:6px" onclick="BtnResultClick()"></i>
                     <b>RESULTS</b>
                  </div>
                  <div class="panel-body" id="result" scrolling="auto"
                      style="overflow-y: scroll;overflow-x: scroll;">
                  </div>
               </div>
           </div>
         </div>
        </div>
      </div>
    </div>

   </div>

      <div class="modal fade" id="gotoline" role="dialog">
        <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Goto Line / Column:</h4>
              <button type="button" class="close" data-dismiss="modal" style="color:black;">&times;</button>
            </div>
            <div class="modal-body" style="padding:40px 50px;">
              <form role="form">
                <div class="form-group">
                  <label for="goline"><span class="fas fa-angle-down"></span> Number Line</label>
                  <input type="text" class="form-control" id="goline" placeholder="Enter Line">
                </div>
                <div class="form-group">
                  <label for="gocol"><i class="fas fa-angle-right"></i> Number Column</label>
                  <input type="text" class="form-control" id="gocol" placeholder="Enter Column">
                </div>
                <button class="btn btn-success btn-block" data-dismiss="modal" onclick="GotoLine()">
                   <span class="far fa-save"></span> Go To</button>
              </form>
            </div>
          </div>
        </div>
      </div> 

      <div class="modal fade" id="harbourcode" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Samples:</h4>
              <button type="button" class="close" data-dismiss="modal" style="color:black;">&times;</button>
            </div>
            <div class="modal-body" style="padding:40px 50px;">
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
      var cItemTree = '';
      var editor = ace.edit('editor');
      editor.setOptions({
            highlightActiveLine: true,
            highlightSelectedWord: true,
            selectionStyle: 'line',
            readOnly: false,
            cursorStyle: "ace",
            behavioursEnabled: true,
            wrapBehavioursEnabled: true,
            autoScrollEditorIntoView: undefined, // boolean: this is needed if editor is inside scrollable page
            keyboardHandler:null,
            animatedScroll: false, // boolean: true if scroll should be animated
            displayIndentGuides: false, // boolean: true if the indent should be shown. See 'showInvisibles'
            showInvisibles: false, // boolean -> displayIndentGuides: true if show the invisible tabs/spaces in indents
            showPrintMargin: false, // boolean: true if show the vertical print margin
            printMarginColumn: 80, // number: number of columns for vertical print margin
            printMargin: undefined, // boolean | number: showPrintMargin | printMarginColumn
            fadeFoldWidgets: true, // boolean: true if the fold lines should be faded
            showFoldWidgets: true, // boolean: true if the fold lines should be shown ?
            showLineNumbers: true,
            hScrollBarAlwaysVisible: true, // boolean: true if the horizontal scroll bar should be shown regardless
            vScrollBarAlwaysVisible: true, // boolean: true if the vertical scroll bar should be shown regardless
            fontSize: 18, // number | string: set the font size to this many pixels
            fontFamily: "Courier New",
            maxLines:undefined,
            minLines:undefined,
            maxPixelHeight:0,
            theme: "ace/theme/monokai",   // theme string from ace/theme or custom?
            dragEnabled: true, // boolean: enable dragging
            useWorker: true, // boolean: true if use web worker for loading scripts
            newLineMode: "auto", // "auto" | "unix" | "windows"
            useSoftTabs: true, // boolean: true if we want to use spaces than tabs
            tabSize: 3, // number
            wrap: true, // boolean | string | number: true/'free' means wrap instead of horizontal scroll, false/'off' means horizontal scroll instead of wrap, and number means number of column before wrap. -1 means wrap at print margin
            indentedSoftWrap: true, // boolean
            foldStyle: "markbegin", // enum: 'manual'/'markbegin'/'markbeginend'.
            mode: "ace/mode/c_cpp", // string: path to language mode 
            enableMultiselect: true,
         });

         editor.commands.addCommand({
             name: "showMenu",
             bindKey: {win: "Alt-a", mac: "Alt-a"},
             exec: function(editor) {
                  $("#menu-toggle").click();
                  editor.focus();
               }
            });
         editor.commands.addCommand({
             name: "showDatos",
             bindKey: {win: "Alt-b", mac: "Alt-b"},
             exec: function(editor) {
                  $("#datos-toggle").click();
                  editor.focus();
               }
            });
         editor.commands.addCommand({
             name: "showCodeResult",
             bindKey: {win: "Alt-c", mac: "Alt-c"},
             exec: function(editor) {
                  $("#code-toggle").click();
                  editor.focus();
               }
            });

      $(document).ready(function () {
         $("#menu-toggle").click(function(e) {
            e.preventDefault();
            $("#wrapper").toggleClass("toggled");
            editor.focus();
            });
         $("#code-toggle").click(function(e) {
            e.preventDefault();
            //$("#wrapper").toggleClass("toggled");
            editor.focus();
            });
         $('#rowDatos').on('shown.bs.collapse', function () {
            $('rowCodeResults').css("height","46.5vh");
            $('#row2').css("height","46.5vh");
            $( ".col-lg-7, .col-lg-5" ).each ( function(index, element) {
                $(element).css("height","46.5vh");
               });
            $("#editor").css("height","88%");
            $("#result").css("height","88%");
            })
         $('#rowDatos').on('hidden.bs.collapse', function () {
            $('#rowCodeResults').css("height","92.1vh");
            $('#row2').css("height","92.1vh");
            $( ".col-lg-7, .col-lg-5" ).each ( function(index, element) {
                $(element).css("height","92.1vh");
               });
            $("#editor").css("height","94%");
            $("#result").css("height","94%");
            })
         $('#rowCodeResults').on('shown.bs.collapse', function () {
            $('#rowDatos').css("height","45.7vh");
            $('#row1').css("height","45.7vh");
            $( ".col-lg-3" ).each ( function(index, element) {
                $(element).css("height","45.7vh");
               });
            $( ".panel-success > .panel-body" ).each ( function(index, element) {
                $(element).css("height","90%");
               });
            })
         $('#rowCodeResults').on('hidden.bs.collapse', function () {
            $('#rowDatos').css("height","92.1vh");
            $('#row1').css("height","92.1vh");
            $( ".col-lg-3" ).each ( function(index, element) {
                $(element).css("height","92.1vh");
               });
            $( ".panel-success > .panel-body" ).each ( function(index, element) {
                $(element).css("height","94%");
               });
            })
            //$('.ls-modal').on('click', function(e){
            //   e.preventDefault();
            //   $('#myModal').modal('show').find('.modal-body').load($(this).attr('href'));
            //});
            //$('.dropdown-item').on('click', function(e){
            //      e.preventDefault();
            //      $('#harbourcode').modal('show').find('.modal-body').load($(this).attr('href'));
            //   });
            $('#goto').on('click',function(){
                  $('#gotoline').modal();
               });

         $("#menu-toggle").click();
         $("#datos-toggle").click();
         $("#code-toggle").click();
         $('#tree1').treed();
         editor.focus();
      });

         function SetResponsive() {
           var x = document.getElementById("myTopnav");
           if (x.className === "navbar") {
             x.className += " responsive";
           } else {
             x.className = "navbar";
           }
         }
         function BtnClassClick() {
            console.log( "Click Class" );
         }
         function BtnDatasClick() {
            console.log( "Click Datas" );
         }
         function BtnMethodsClick() {
            console.log( "Click Method" );
         }
         function BtnFunctionsClick() {
            console.log( "Click Functions" );
         }
         function BtnEditorClick() {
            console.log( "Click Editor" );
         }
         function BtnResultClick() {
            console.log( "Click Result" );
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

        function FunctionsClick( cstr ) {
           $('#result').html( "" );
           $('#result').scrollTop( 0 );
           $('#result').html( cstr );
        }

        function editor_run( bprog ) {
          //var ext = ctab.split('.').pop().toLowerCase();
          //if ( ext == 'prg' | ext == 'hrb' ) {
          if( bprog ) {
             Run();
           }
          else {
          //   if ( ext == "html" | ext == "htm" | ext == "view" | ext == "tpl" ) {
             var text = editor.getValue()
             text     = text.replace( /\\n/g, "<br>" );
             document.getElementById("result").innerHTML = text;
           }
          //}
          editor.focus();
        }

        function show_memory() {
           var text = <?prg return GetTextFile( cMemory ) ?>;
           editor.setValue( "", -1 );
           text     = text.replace( /\\|\\|\\|/g, "\\r\\n" );
           editor.setValue( text, -1 );
           editor_run( true );
        }

         function Clear( onlyresult ) {
            var text = editor.getValue();
            editor.setValue( '', -1 );
            editor_run( true );
            if( onlyresult ) {
               editor.setValue( text, -1 );
              }
            editor.focus();
         }

         function Run1()
         {
            var o = new Object();
            o[ 'source' ] = editor.getValue();
            //console.log( 'PARAM', o );
            $.post( '<?prg return FileRun() ?>', o )
               .done( function( data ) { console.log( 'DONE', data ); $('#result').html( data ); } )
               .fail( function( data ) { console.log( 'ERROR', data ); } ); 
         }

      $.fn.extend({
          treed: function (o) {
            var openedClass = 'fas fa-chevron-down'; //'fas fa-chevron-right';
            var closedClass = 'far fa-plus-square';
            
            if (typeof o != 'undefined'){
              if (typeof o.openedClass != 'undefined'){
                 openedClass = o.openedClass;
              }
              if (typeof o.closedClass != 'undefined'){
              closedClass = o.closedClass;
              }
            };
            
              var tree = $(this);
              tree.addClass("tree");

              tree.find('li:not(:has("ul"))').each(function () {
                 var branch = $(this); //li with children 
                 branch.on('click', function (e) {
                    branch.addClass( "active" );
                    branch.siblings().removeClass( "active" );
                    cItemTree = $(e.target)[0].text ;
                    //DatasOfClass();
                   })
                 });

                 tree.find('li').has("ul").each(function () {
                    var branch = $(this); //li with children ul
                    branch.prepend("<i class='indicator " + closedClass + "'" + 'style="color:#0A0A2A;padding:8px;"' + "></i>");
                    branch.addClass('branch');
                    branch.on('click', function (e) {
                        if (this == e.target) {
                            var icon = $(this).children('i:first');
                            icon.toggleClass( closedClass + " " + openedClass );
                            $(this).children().children().toggle();
                            $(this).addClass( "active" );
                            $(this).siblings().removeClass( "active" );
                            cItemTree = $(e.target.innerHTML)[1].text;
                            //DatasOfClass();
                        }
                    })
                    branch.children().children().toggle();
                    //branch.children().children().toggle();
                 });

              //fire event from the dynamically added icon
              //tree.find('.branch .indicator').each(function(){
              //   $(this).on('click', function () {
              //   console.log( $(this) );
              //   $(this).closest('li').click();
              //   });
              // });

              tree.find('.indicator').each(function(){
                 $(this).on('click', function () {
                 $(this).closest('li').click();
                 console.log( cItemTree );
                 });
               });

              //fire event to open branch if the li contains an anchor instead of text
              tree.find('.branch>a').each(function () {
                  $(this).on('click', function (e) {
                      $(this).closest('li').click();
                      e.preventDefault();
                  });
              });
              //fire event to open branch if the li contains a button instead of text
              tree.find('.branch>button').each(function () {
                  $(this).on('click', function (e) {
                      $(this).closest('li').click();
                      e.preventDefault();
                  });
              });
            //function toggleColor( o )
            //{
            //   $( o ).addClass( "active" );
            //   $( o ).siblings().removeClass( "active" );
            //}
          }
      });
      
      //Initialization of treeviews
      //$('#tree1').treed();

   </script>

</body>

</html>


   ENDTEXT

Return nil

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

Function GetAllClasses()

   local oClass

   aClasses := {}
   GetClasses()
   //for each oClass in aClasses
   //   if Empty( oClass:cSuper )
   //      AddChilds( oTree:Add( oClass:cName ), oClass:aChilds )
   //   endif
   //next

Return nil

//----------------------------------------------------------------------------//

function GetClasses()

   local n  := 1
   local oClass

   aClasses := {}
   while ! Empty( __ClassName( n ) )
      AAdd( aClasses, oClass := TClass():New( __ClassName( n++ ) ) )
   end

   for each oClass in aClasses
      oClass:GetSuper()
   next

   for each oClass in aClasses
      oClass:GetChilds()
   next

return aClasses

//----------------------------------------------------------------------------//

CLASS TClass

   DATA   cName
   DATA   cSuper
   DATA   aChilds INIT {}
   DATA   aDatas
   DATA   aMethods

   METHOD New( cName )
   METHOD GetSuper()
   METHOD GetChilds()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName ) CLASS TClass

   ::cName  := cName
   ::cSuper := ""

Return Self

//----------------------------------------------------------------------------//

METHOD GetSuper() CLASS TClass

   local oClass
   local oInstance
   local aDats   := {}
   local aCDats  := {}
   local oErr
      
   TRY         //BEGIN SEQUENCE
      oInstance := &( ::cName + "()" )
   CATCH oErr      //RECOVER
      //? GetErrorInfo( oErr )
      //BREAK
   FINALLY
      if !Empty( oErr )
         oInstance := &( "_" + ::cName + "()" )
      endif
   END //SEQUENCE

   if hb_IsObject( oInstance )
      if ::aDatas == nil
         ::aDatas     := {}
         //::aDatas   := __objGetMsgList( oInstance, .T. )
         //::aDatas     := __objGetValueList( oInstance )
         //::aDatas     := __objGetIVars( oInstance,, .T. )
         aDats        := __objGetMsgList( oInstance, .T., 2 )
         aCDats       := __objGetMsgList( oInstance, .T., 1 )
         //AEVal( aCDats, { | a | AAdd( ::aDatas, "[ C ] " + a ) } )
         //AEVal( aDats,  { | a | AAdd( ::aDatas, "[ D ] " + a ) } )
         AEVal( aCDats, { | a | AAdd( ::aDatas, a ) } )
         AEVal( aDats,  { | a | AAdd( ::aDatas, a ) } )
         
         ::aMethods := __objGetMsgList( oInstance, .F. )
      endif

      for each oClass in aClasses
         BEGIN SEQUENCE
            if __objHasMethod( oInstance, "ISDERIVEDFROM" )
               if oInstance:IsDerivedFrom( oClass:cName ) .and. ::cName != oClass:cName
                  ::cSuper := oClass:cName 
               endif
            else
            endif
         RECOVER
         END SEQUENCE
      next
   else
      //? ::cName + "()"
   endif      

return nil

//----------------------------------------------------------------------------//

METHOD GetChilds() CLASS TClass

   local oClass

   for each oClass in aClasses
      if oClass:cSuper == ::cName
         AAdd( ::aChilds, oClass )
      endif
   next

return nil

//----------------------------------------------------------------------------//

Function _Error()
return ErrorNew()

//----------------------------------------------------------------------------//

Function Hash()
return {=>} //Hash():New() //

//----------------------------------------------------------------------------//

Function _Pointer()
return @Pointer() //:New()

//----------------------------------------------------------------------------//

Function _ScalarObject()
Return @ScalarObject() //:New()

//----------------------------------------------------------------------------//

Function _Logical()
Return @Logical()

//----------------------------------------------------------------------------//

Function _Nil()
Return nil

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

CLASS TObject FROM HBObject

ENDCLASS

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

Function ReadMemoryPrg()
Return hb_MemoRead( AP_GetEnv( "DOCUMENT_ROOT" ) + "/modharbour_samples/memory.prg" )

//----------------------------------------------------------------------------//

Function FileRun()
Return cFileRun

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//

Function GetTextFile( cFile, lTran )

   local cText    := ""
   local nLines   := 0
   local cResult  := "''"
   local x
   if File( cFile )
      cText    := hb_Memoread( cFile )
      nLines   := Len( hb_aTokens( cText, chr( 10 ) ) )
      lTran          := hb_defaultValue( lTran, .T. )
      if lTran
         cText          := StrTran( cText, '"', "'" )
      endif
      if nLines > 0
         cResult  := ""
         For x = 1 to nLines
             cResult    += '"' + AllTrim( MemoLine( cText, 160, x ) ) + ;
                           if( x < nLines, '|||" + ', '"' )
         Next x
      endif
   endif

return cResult

//----------------------------------------------------------------------------//

Function InstanceClass( cFileIni )

   local x
   local nLines
   local aLines  := {}
   local cText   := ""
   local cClass

   if File( cFileIni )
      cText      := hb_Memoread( cFileIni )
      aLines     := hb_aTokens( cText, chr( 10 ) )
      nLines     := Len( aLines )
      For x = 1 to nLines
         cClass  := aLines[ x ]
         cClass  := StrTran( cClass, Chr( 13 ), "" )
         cClass  := AllTrim( cClass )
         if !Empty( cClass )
            cClass  += "()"
            BEGIN SEQUENCE
               &( cClass )
            RECOVER
            END SEQUENCE
         endif
      Next x
   endif

Return nil

//----------------------------------------------------------------------------//

Function CreateTree()

   local cItems := ""
   local oItem
   local oClass
   local cChild := ""

   for each oClass in aClasses
      cChild    := ""
      if Empty( oClass:cSuper )
         cChild := CreateChild( oClass )
         if !Empty( cChild )
            cItems += '<li><a class="classes" href="#" ' + ;
                      GetFunFocus( 0, oClass ) + '>' + ;
                      AllTrim( oClass:cName ) + "</a>" + CRLF
            cItems += '<ul>' + CRLF
            cItems += cChild
            cItems += '</ul>' + CRLF
         else
            cItems += '<li><a class="classes" href="#" ' + ;
                      GetFunFocus( 0, oClass ) + '>' + ;
                      "<i class='indicator " + 'fas fa-angle-right' + "'" + ;
                      'style="color:gray;padding:8px;"' + "></i>" + ;
                      AllTrim( oClass:cName ) + "</a>" + CRLF
         endif
         cItems += '</li>' + CRLF
      endif
   next

Return cItems

//----------------------------------------------------------------------------//

Function CreateChild( oClass )

   local cItems := ""
   local oItem
   local cChild := ""

   for each oItem in oClass:aChilds
      cChild    := ""
      cChild    := CreateChild( oItem )
      if !Empty( cChild )
         cItems += '<li><a class="classes" href="#" ' + ;
                    GetFunFocus( 0, oItem ) + '>' + ;
                    AllTrim( oItem:cName ) + "</a>" + CRLF
         cItems += '<ul>' + CRLF
         cItems += cChild
         cItems += '</ul>' + CRLF
      else
         cItems += '<li><a class="classes" href="#" ' + ;
                   GetFunFocus( 0, oItem ) + '>' + ;
                   "<i class='indicator " + 'fas fa-angle-right' + "'" + ;
                     'style="color:#0A0A2A;padding:8px;"' + "></i>" + ;
                      AllTrim( oItem:cName ) + "</a>" + CRLF
      endif
      cItems    += '</li>' + CRLF
   next

Return cItems

//----------------------------------------------------------------------------//

Function GetFunFocus( nType, oItem )

   local cItem
   Do Case
      Case nType = 0
         cItem   := 'onfocus="' + ;
                    '$(' + "'#datas'" + ').html( ' + ;
                    "'<a>" + ;
                    '<?prg return GetDatasOfClass( ' + "'" + AllTrim( oItem:cName ) + "'" + ' ) ?>' + ;
                    "</a>'" + ;
                    ' );' + ;
                    '$(' + "'#methods'" + ').html( ' + ;
                    "'<a>" + ;
                    '<?prg return GetMethodsOfClass( ' + "'" + AllTrim( oItem:cName ) + "'" + ' ) ?>' + ;
                    "</a>'" + ;
                    ' )"' //+ "'"
      Case nType = 1
         cItem   := 'onfocus="DatasOfClass( ' + "'" + AllTrim( oItem:cName ) + "'" + ' )"'
   EndCase

Return cItem

//----------------------------------------------------------------------------//

Function GetDatasOfClass( cClass )

   local cItems := ""
   local x
   local nPos   := 0
   nPos         := AsCan( aClasses, { | o | AllTrim( o:cName ) == AllTrim( cClass ) } )
   if !Empty( nPos )
      if !Empty( aClasses[ nPos ]:aDatas )
         For x = 1 to Len( aClasses[ nPos ]:aDatas )
            cItems += '<a href=&quot;#&quot; class=&quot;data&quot;>' + ;
                       if( Valtype( aClasses[ nPos ]:aDatas[ x ] ) = "A", ;
                       AllTrim( aClasses[ nPos ]:aDatas[ x ][ 1 ] ), ;
                       AllTrim( aClasses[ nPos ]:aDatas[ x ] ) ) + "</a><br>"
         Next x
      else
            cItems += '<a>' + ;
                       'NON DATAS' + "</a><br>"
      endif
   endif

Return cItems

//----------------------------------------------------------------------------//

Function GetMethodsOfClass( cClass )

   local cItems := ""
   local x
   local nPos   := 0
   nPos         := AsCan( aClasses, { | o | AllTrim( o:cName ) == AllTrim( cClass ) } )
   if !Empty( nPos )
      if !Empty( aClasses[ nPos ]:aDatas )
         For x = 1 to Len( aClasses[ nPos ]:aMethods )
            cItems += '<a href=&quot;#&quot; class=&quot;meth&quot;>' + ;
                       AllTrim( aClasses[ nPos ]:aMethods[ x ] ) + "</a><br>"
         Next x
      else
            cItems += '<a>' + ;
                       'NON METHODS' + "</a><br>"
      endif
   endif

Return cItems

//----------------------------------------------------------------------------//

Function GetFunctions()

   local cItems := ""
   local cFile  := HB_GETENV( 'PRGPATH' ) + '/HFuncs2.dbf'
   cAliasFunc   := "HFuncs"
   USE ( cFile ) ALIAS ( cAliasFunc ) SHARED
   SET ORDER TO TAG FFUNC
   ( cAliasFunc )->( DbGoTop() )
   Do While !( cAliasFunc )->( Eof() )
      cItems += '<a class="funcs" href="#"' + ;
                 ' onclick="' + 'FunctionsClick(' + "'" + ;
                 if( !Empty( ( cAliasFunc )->( FieldGet( 5 ) ) ), ;
                 '<a href=&quot;' + GetTransformText( AllTrim( ( cAliasFunc )->( FieldGet( 5 ) ) ), .T. ) + ;
                  "&quot;>View Source Code</a>", "" ) + "<br><br>" + ;
                 '<a><b><h6>' + GetTransformText( AllTrim( ( cAliasFunc )->( FieldGet( 6 ) ) ), .T. ) + "</h6></b><br>" + ;
                 GetTransformText( AllTrim( ( cAliasFunc )->( FieldGet( 9 ) ) ) ) + "<br><br>" + ;
                 GetTransformText( AllTrim( ( cAliasFunc )->( FieldGet( 12 ) ) ) ) + ;
                 '</a>' + ;
                 "')" + '"' +;
                 '>' + ;
                 AllTrim( ( cAliasFunc )->( FieldGet( 3 ) ) ) + '</a><br>'
      //                 GetTransformText( ( cAliasFunc )->( FieldGet( 12 ) ) ) + ;

      //cItems += '<a>' + ;
      //          AllTrim( ( cAliasFunc )->( FieldGet( 3 ) ) ) + "</a><br>"
      
      ( cAliasFunc )->( DbSkip() )
   Enddo
   ( cAliasFunc )->( DbCloseArea() )

Return cItems

//----------------------------------------------------------------------------//

Function GetFunctionField( cSearch, nField )

   local cItems := ""
   local cFile  := HB_GETENV( 'PRGPATH' ) + '/HFuncs2.dbf'
   cAliasFunc   := "HFuncs"
   USE ( cFile ) ALIAS ( cAliasFunc ) SHARED VIA "DBFCDX"
   SET ORDER TO TAG FFUNC
   //if ( cAliasFunc )->( DbSeek( cSearch ) )
   //   cItems    := ( cAliasFunc )->( FieldGet( nField ) )
   //endif
   cItems    := ( cAliasFunc )->( FieldGet( 12 ) )
   ( cAliasFunc )->( DbCloseArea() )

Return cItems

//----------------------------------------------------------------------------//

Function GetTransformText( cStr, lRet )

   if !hb_Isnil( cStr )
      cStr  := StrTran( cStr, "ÿ|ÿ", "<br>" )
      cStr  := StrTran( cStr, "??", "<br>" )
         cStr  := StrTran( cStr, "=>", "---" )
         cStr  := StrTran( cStr, ">Syntax", "><b><h6>Syntax</h6></b>" )
         cStr  := StrTran( cStr, ">Arguments", "><b><h6>Arguments</h6></b>" )
         cStr  := StrTran( cStr, ">Returns", "><b><h6>Returns</h6></b>" )
         cStr  := StrTran( cStr, ">Description", "><b><h6>Description</h6></b>" )
         cStr  := StrTran( cStr, ">Examples", "><b><h6>Examples</h6></b>" )
         cStr  := StrTran( cStr, ">Status", "><b><h6>Status</h6></b>" )
         cStr  := StrTran( cStr, ">Compliance", "><b><h6>Compliance</h6></b>" )
         cStr  := StrTran( cStr, ">Platforms", "><b><h6>Platforms</h6></b>" )
         cStr  := StrTran( cStr, ">File", "><b><h6>File</h6></b>" )
         cStr  := StrTran( cStr, ">Tags", "><b><h6>Tags</h6></b>" )
         cStr  := StrTran( cStr, ">See also", "><b><h6>See also</h6></b>" )
         cStr  := StrTran( cStr, ">Source code", "><br><h6>Source code</h6>" )
         cStr  := StrTran( cStr, ">in Discussions", "><h6>in Discussions</h6>" )
         cStr  := StrTran( cStr, ">in Repository", "><h6>in Repository</h6>" )
         cStr  := hb_StrToUtf8( FHtmlEncode( cStr, lRet ) )
   else
      cStr  := ""
   endif
Return cStr

//----------------------------------------------------------------------------//

function FHtmlEncode( cString, lRet )

  local nI
  local cI
  local cRet  := ""

  for nI := 1 to Len( cString )
     cI := SubStr( cString, nI, 1 )
     if cI == "<"
        if hb_IsNil( lRet )
           cRet += "&lt;"
        else
           cRet += " "
        endif
     elseif cI == ">"
        if hb_IsNil( lRet )
           cRet += "&gt;"
        else
           cRet += " "
        endif
     elseif cI == '"'
        cRet += "&quot;"
     elseif cI == "'"
        cRet += ""
     elseif cI = Chr( 10 )
        cRet += "&lt;br&gt;"
     elseif cI = Chr( 13 )
        cRet += ""
     else
        cRet += cI
     endif
  next nI

return cRet

//----------------------------------------------------------------------------//
