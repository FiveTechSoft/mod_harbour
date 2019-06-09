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
   }

.vsplitbar {
	width: 4px;
	background: #159957;
   }
</style>
   </head>
   <body>
      <div class="container-fluid">
         <nav class="navbar navbar-inverse" 
              style="background-color:#159957;background-image:linear-gradient(120deg, #155799, #159957);height:11%;">
            <div class="navbar-header">
               <a class="navbar-brand" href="https://fivetechsoft.github.io/mod_harbour/"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span></a>
               <a class="navbar-brand" onclick="MsgInfo( 'Run your tests here!' )">mod_harbour sandbox</a>
               <a class="navbar-brand" href="#"></a>
            </div>
            <ul class="nav navbar-nav">
               <li><button class="btn btn-success navbar-btn" onclick="Run()"><span class="glyphicon glyphicon-flash"></span> Run</button></li> 
               <div class="col-sm-1";>
               <button class="btn btn-success navbar-btn" onclick="Clear()"><span class="glyphicon glyphicon-edit"></span> Clear</button>
               </div>
               <a class="navbar-brand" href="#"></a>
               <div class="col-sm-1";>
               <button class="btn btn-success navbar-btn" onclick="Download()"><span class="glyphicon glyphicon-save"></span> Save</button>
               </div>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <a class="navbar-brand" href="#"></a>
               <div class="col-sm-2";>
               <input type="file" class="btn btn-success navbar-btn" name="SelectFile" id="selectfile" accept=".prg" onchange="openFile(event)"><br>
               </div>
            </ul>
         </nav>
      </div>
         <ul class="nav nav-tabs" id="tabs" role="tablist" style="background-color:lightgray;">
            <li class="active" id="tab1"><a href="#row1" role="tab" data-toggle="tab">Noname</a></li>
         </ul>
      <div class="row" id="row1" style="background-color:silver;width:101.0%;height:82.5%;">
         <div class="col-sm-7" style="background-color:silver;height:99.5%;">
         <div id="editor" style="height:100%;">function Main()

   ? "Hello world"

return nil</div>
         </div>
         <div class="col-sm" id="result" style="background-color:LightYellow;width:99.6%;height:99.5%;"></div>
      </div>
      <script src="https://fivetechsoft.github.io/xcloud/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
      <script>
         var editor = ace.edit("editor");
         editor.setTheme("ace/theme/pastel_on_dark");
         editor.setFontSize(16);     
         editor.setHighlightActiveLine(true);
         editor.session.setMode("ace/mode/c_cpp");
         //editor.setShowPrintMargin(false);

         function Download(filename) {
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
            editor.setValue( text );
            Run();
            selectfile.value = '';
            $('#tabs a:last').text( "Noname" );
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
            editor.setValue( text );
          }
            //addtab();
            $('#tabs a:last').text( input.files[0].name );
        }

        function addtab() {
          	var nextTab = $('#tabs li').size()+1;
          	// create the tab
          	//$('<li><a href="#tab'+nextTab+'" data-toggle="tab">Tab '+nextTab+'</a></li>').appendTo('#tabs');
            $('<li><a href="#row1"'+'" data-toggle="tab">Tab '+nextTab+'</a></li>').appendTo('#tabs');
          	// create the tab content
          	$('<div class="tab-pane" id="tab'+nextTab+'">tab' +nextTab+' content</div>').appendTo('.tab-content');
          	// make the new tab active
          	$('#tabs a:last').tab('show');
        }

      $().ready(function () {
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

/**
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
                initPos = Math.round(0.59*(splitter[0][opts.pxSplit] - splitter._PBA - bar._DA) );

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
