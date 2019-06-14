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
    content: '[+]';
}

ul.tree li.open > a:not(:last-child):before {
    content: '[-]';
}
</style>
<ul class="tree">
  <li><a href="#">Part 1</a>
    <ul>
      <li><a href="#">Item A</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item B</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item C</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item D</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item E</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
    </ul>
  </li>

  <li><a href="#">Part 2</a>
    <ul>
      <li><a href="#">Item A</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item B</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item C</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item D</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item E</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
    </ul>
  </li>

  <li><a href="#">Part 3</a>
    <ul>
      <li><a href="#">Item A</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item B</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item C</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item D</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
      <li><a href="#">Item E</a>
        <ul>
          <li><a href="#">Sub-item 1</a></li>
          <li><a href="#">Sub-item 2</a></li>
          <li><a href="#">Sub-item 3</a></li>
        </ul>
      </li>
    </ul>
  </li>
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
