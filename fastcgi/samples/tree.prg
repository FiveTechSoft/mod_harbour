function Main()

   TEMPLATE
<style>
body {
    font-family: Arial;
}

ul.tree li {
    list-style-type: none;
    position: relative;
}

ul.tree li ul {
    display: none;
}

ul.tree li.open > ul {
    display: block;
}

ul.tree li a {
    color: black;
    text-decoration: none;
}

ul.tree li a:before {
    height: 1em;
    padding:0 .1em;
    font-size: .8em;
    display: block;
    position: absolute;
    left: -1.3em;
    top: .2em;
}

ul.tree li > a:not(:last-child):before {
    content: '+ ';
}

ul.tree li.open > a:not(:last-child):before {
    content: '- ';
}

</style>
<ul class="tree">
<?prg local nPart, nItem, nSubItem
      local cItems := ""
      
      for nPart = 1 to 5
         cItems += '<li><a href="#">  Part ' + AllTrim( Str( nPart ) ) + "</a>" + CRLF
         cItems += '<ul>' + CRLF
         for nItem = 1 to 4
            cItems += '<li><a href="#"> Item ' + AllTrim( Str( nItem ) ) + "</a>" + CRLF
            cItems += '<ul>' + CRLF
            for nSubItem = 1 to 3
               cItems += '<li><a href="#"> SubItem ' + AllTrim( Str( nSubItem ) ) + "</a></li>" + CRLF
            next
            cItems += '</ul>' + CRLF
         next  
         cItems += '</li>' + CRLF
         cItems += '</ul></li>' + CRLF
      next
      
      return cItems ?>
</ul>

<script>
var tree = document.querySelectorAll('ul.tree a:not(:last-child)');
for(var i = 0; i < tree.length; i++){
    tree[i].addEventListener('click', function(e) {
        var parent = e.target.parentElement;
        var classList = parent.classList;
        if(classList.contains("open")) {
            classList.remove('open');
            var opensubs = parent.querySelectorAll(':scope .open');
            for(var i = 0; i < opensubs.length; i++){
                opensubs[i].classList.remove('open');
            }
        } else {
            classList.add('open');
        }
    });
}
</script>
ENDTEXT

return nil
