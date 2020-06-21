function Main()

   TEMPLATE
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Type', 'Megabytes'],
          ['HB_MEM_CHAR',  10 ],
          ['HB_MEM_BLOCK', 20 ],
          ['HB_MEM_RUN',   30 ],
          ['HB_MEM_VM',    40 ],
        ]);

        var options = {
          title: 'mod_harbour > The Virtual Machine > Memory Management',
          is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="piechart_3d" style="width: 1200px; height: 800px;"></div>
  </body>
</html>
   ENDTEXT

return nil
