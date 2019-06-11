function Main()

   TEMPLATE
   <html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, shrink-to-fit=no">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://fivetechsoft.github.io/xcloud/source/js/xcloud.js"></script>
      <link rel="stylesheet" href="https://fivetechsoft.github.io/xcloud/source/css/xcloud.css"> 
      <title>Sandbox</title>
<style>

.container-fluid {
   color:#2C2828;
   background-color:#F5F5F5;
   }

#editor { 
   position: absolute;
   top: 0;
   right: 0;
   bottom: 0;
   left: 15;
   }

#tabs { 
   position: relative;
   top: 0;
   right: 0;
   bottom: 0;
   left: 0;
   padding-top: 0px; 
   padding-bottom: 0px;
   }

.btn {
   color:white;
   background-color:#2C2828;
   }

.btn:hover {
   color: #2C2828;
   background-color: #ffff;
   }

.btn:focus {
   color: #2C2828;
   background-color: #ffff;
   }

.vsplitbar {
	width: 4px;
	background: LightGray;
   }

body {
   background-color: #F5F5F5;
   }

.nav-tabs > li {
   margin-left:0px;
   position:relative;    
}

.nav-tabs > li > a
   {
   padding-top: 5px; 
   padding-bottom: 5px;
   padding-right: 25px;
   display:inline-block;
   }

.nav-tabs > li > span {
    display:none;
    cursor:pointer;
    position:absolute;
    right: 10px;
    top: 6px;
    color: red;
}

.nav-tabs > li:hover > span {
    display: inline-block;
}

.nav-tabs > li.active > a {
   color:#2C2828;
   background-color: white;
   }

.nav-tabs > li.active > a:focus 
   {
   color:white;
   background-color:gray;
   }

.nav-tabs > li.active > a:hover {
   color:white;
   background-color:lightgray;
   }

</style>

   </head>
   <body>
      <div class="container-fluid">
         <nav class="navbar navbar-inverse" 
              style="background-color:LightGray;border:0px;height:8%;">
            <div class="nav navbar-nav">
               <a class="navbar-brand" href="https://fivetechsoft.github.io/mod_harbour/" style="color: #2C2828;">
                  <span class="glyphicon glyphicon-menu-hamburger" height="36" aria-hidden="true"></span> SandBox</a>
               <li><button class="btn navbar-btn btn-sm" onclick="Run()" title="[ F9 ]"><span class="glyphicon glyphicon-flash"></span> Run</button></li>
               <li><button class="btn navbar-btn btn-sm" onclick="Download()" title="[ Ctrl + S ]"><span class="glyphicon glyphicon-save"></span> Save</button></li>
               <a class="navbar-brand" href="#"></a>
               <li><button class="btn navbar-btn btn-sm" onclick="Clear()" title="[ F5 ]"><span class="glyphicon glyphicon-edit"></span> Clear</button></li>
               <a class="navbar-brand" href="#"></a>
               <li><button class="btn navbar-btn btn-sm" onclick="editor.undo()" title="[ Ctrl + Z ]"><span class="glyphicon glyphicon-repeat"></span> Undo</button></li>
               <li><button class="btn navbar-btn btn-sm" onclick="editor.redo()" title="[ Ctrl + A ]"><span class="glyphicon glyphicon-refresh"></span> Redo</button></li>
               <div class="col-sm-1";>
               <input type="file" class="btn navbar-btn btn-sm" name="SelectFile" id="selectfile" accept=".prg" onchange="openFile(event)"><br>
               </div>
            </div>
         </nav>
      </div>
      <ul class="nav nav-tabs" id="tabs" role="tablist" style="background-color:#F5F5F5;">
         <li class="active" id="tab1"><a href="#row1" role="tab">Noname1.prg</a>
         <span>x</span></li>
      </ul>
      <div class="tab-content">
      <div class="row" id="row1" style="background-color:#F5F5F5;width:101.0%;height:82.5%;">
         <div class="col-sm-7" style="background-color:#F5F5F5;height:99.5%;">
         <div id="editor" style="height:100%;">function Main()

   ? "Hello world"

return nil</div>
         </div>
         <div class="col-sm" id="result" style="background-color:#F5F5F5;width:99.6%;height:99.5%;"></div>
      </div>
      </div>
      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
      <script>
         var ctab = '' ;
         var textos = [];
         //ace.require("ace/ext/language_tools");
         var editor = ace.edit("editor");
         editor.setTheme("ace/theme/twilight"); //monokai");    //pastel_on_dark
         editor.setFontSize(16);
         editor.setHighlightActiveLine(true);
         editor.session.setMode("ace/mode/c_cpp");
         editor.session.setTabSize(3);
         editor.session.setUseSoftTabs(true);
         var EditSession1 = ace.require("ace/edit_session").EditSession;
         editor.commands.addCommand({
            name: 'Run',
            bindKey: {win: 'F9',  mac: 'F9'},
            exec: function(editor) {
               Run();
               },
             readOnly: true // false if this command should not apply in readOnly mode
          });
         editor.commands.addCommand({
            name: 'Clear',
            bindKey: {win: 'F5',  mac: 'F5'},
            exec: function(editor) {
               Clear();
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
            name: 'Undo',
            bindKey: {win: 'Ctrl-Z',  mac: 'Command-Z'},
            exec: function(editor) {
               editor.undo();
               },
             readOnly: true // false if this command should not apply in readOnly mode
          });
         editor.commands.addCommand({
            name: 'Redo',
            bindKey: {win: 'Ctrl-A',  mac: 'Command-A'},
            exec: function(editor) {
               editor.redo();
               },
             readOnly: true // false if this command should not apply in readOnly mode
          });
         editor.commands.addCommand({
            name: 'Redo',
            bindKey: {win: 'Ctrl-O',  mac: 'Command-O'},
            exec: function(editor) {
               window.alert( "Press CTRL + F: dialog Search and Replace");
               },
             readOnly: true // false if this command should not apply in readOnly mode
          });

         //editor.session.foldStyle( "markbegin" );
         //editor.session.fadeFoldWidgets( true );
         //editor.session.showFoldWidgets( true );
         //editor.showPrintMargin( true );
         //editor.session.setShowPrintMargin(true);
         //var EditSession = require("https://fivetechsoft.github.io/xcloud/lib/ace/edit_session").EditSession;
         //editor.setAutoScrollEditorIntoView(true);
         //editor.setOption("maxLines", 26);
         //editor.setOption("minLines", 26);
         textos[ $('#tabs a:last').text() ] = editor.getValue();

         editor.session.on('change', function(delta) {
            // delta.start, delta.end, delta.lines, delta.action
            //if ( editor.session.getLength() > 1 ) {
            //   textos[ ctab ] = editor.getValue();
            //   }
            //else {
            //      if( editor.getLine( 1 ) != '' ) {
            //         textos[ ctab ] = editor.getValue();
            //      }
            //   }
          })

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

         function Download() {
            var filename = $('#tabs a:last').text();
            var content = editor.getValue();
            var pom = document.createElement('a');
            pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(content));
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

         function Clear() {
            var text = '';
            //var nextTab = $('#tabs').children().length;
            editor.setValue( text,1 );
            Run();
            selectfile.value = '';
            //$(".nav-tabs li").children('a').text( "Noname" + nextTab + ".prg" );
            //$(".nav-tabs li").children('a').last().focus();
            //window.alert( ctab );
            textos[ ctab ] = text;
         }

         function openFile(event) {
            var text = '';
            editor.setValue( text );
            Run();
            var input = event.target;
            var reader = new FileReader();
            reader.readAsText( input.files[0] );
            reader.onload = function(){
            var text = reader.result;
            addtab( input.files[0].name );
            editor.setValue( text, -1 );
            textos[ $('#tabs a:last').text() ] = text;
          }
        }

        function addtab( name ) {
            var nextTab = $('#tabs').children().length+1;
            //window.alert(nextTab);
            $('<li class="active" id="tab'+nextTab+'"'+ '><a href="#row1" role="tab">+"Tab"+</a><span>x</span></li>').appendTo('#tabs');
          	//$('<div class="row" id="row1'+nextTab+'"'+'>'+$('#row1')+'</div>').appendTo('.tab-content');
            $('<div class="row" id="row1">'+'</div>').appendTo('.tab-content');
            $('#tabs a:last').text( name );
          	$('#tabs a:last').show();
            $('#tabs a:last').focus();
        }

        $(document).ready(function () {
           $(".nav-tabs").on("click", "a", function(e){
              //var current_tab = e.target;
              //var previous_tab = e.relatedTarget;
              e.preventDefault();
              ctab = $(this).text();
              //window.alert( $(this).text() );
              editor.setValue('',1);
              Run();
              editor.setValue( textos[ ctab ], -1 );
              //window.alert( ctab );
              $(this).show(); //tab('show');
              $(this).focus();
           })
           .on("click", "span", function () {
              var anchor = $(this).siblings('a');
              var nextTab = $('#tabs').children().length;
              //var ctab   = '';
              //window.alert( anchor.text() );
              if ( nextTab > 1 ) {
                 textos.splice( anchor.text(), 1);
                 //$(anchor.attr('href')).remove();
                 $(this).parent().remove();
                 ctab = $(".nav-tabs li").children('a').last().text() ;
                 //window.alert( ctab );
                 editor.setValue('',1);
                 Run();
                 editor.setValue( textos[ ctab ], -1 );
                 $(".nav-tabs li").children('a').last().click();
                 $(".nav-tabs li").children('a').last().focus();
                 selectfile.value = ctab;
                 //$('#selectfile').value = ctab;
              }
            });

           //$('.nav-tabs a').on( "shown.bs.tab", function (e) {
           //    window.alert('Hello from the other siiiiiide!');
           //    var current_tab = e.target;
           //    var previous_tab = e.relatedTarget;
           //    ctab = current_tab.text();
           //});

           $(".nav-tabs li").children('a').last().click();
           //$(".nav-tabs li").children('a').last().focus();

           $("#row1").splitter();
        });

/*
 * jQuery.splitter.js - two-pane splitter window plugin
 *
 * version 1.51 (2009/01/09) 
 * 
 * Dual licensed under the MIT and GPL licenses: 
 *   https://www.opensource.org/licenses/mit-license.php 
 *   http://www.gnu.org/licenses/gpl.html 
 */

/*
 * The splitter() plugin implements a two-pane resizable splitter window.
 * The selected elements in the jQuery object are converted to a splitter;
 * each selected element should have two child elements, used for the panes
 * of the splitter. The plugin adds a third child element for the splitbar.
 * 
 * For more details see: http://methvin.com/splitter/
 *
 *
 * @example $('#MySplitter').splitter();
 * @desc Create a vertical splitter with default settings 
 *
 * @example $('#MySplitter').splitter({type: 'h', accessKey: 'M'});
 * @desc Create a horizontal splitter resizable via Alt+Shift+M
 *
 * @name splitter
 * @type jQuery
 * @param Object options Options for the splitter (not required)
 * @cat Plugins/Splitter
 * @return jQuery
 * @author Dave Methvin (dave.methvin@gmail.com)
 */
      ; (function ($) {

      $.fn.splitter = function (args) {
         args = args || {};
        
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
                      opera : /opera/.test(navigator.userAgent.toLowerCase())
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
                initPos = Math.round(0.55*(splitter[0][opts.pxSplit] - splitter._PBA - bar._DA) );

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
