

dataSet = {
  labels: _(labels).map((label, index) => if index % 2 == 0 then '' else label),
  datasets: [
    {
      strokeColor : "#dcdcdc",
      pointColor : "#dcdcdc",
      pointStrokeColor : "#ffffff",
      data: values[1]
    },
    {
      strokeColor : "#ff9933",
      pointColor :  "#ff9933",
      pointStrokeColor : "#ffffff",
      data : values[0]
    }
  ]
}

new Chart($("#chart").get(0).getContext("2d")).Line(dataSet, {
  # -- global options --
  animation: false
  responsive: true
  scaleShowLabels: false
  showTooltips: false
  # -- line chart options --
  bezierCurve: false
  datasetFill: false
})