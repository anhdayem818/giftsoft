$(document).ready ()->
  $.plot($("#flot-placeholder"),
    [ report_data ], {
    points: { show: false },
    xaxis:{ mode: "time", timeformat: "%d-%m", autoscaleMargin: 0.05},
    bars: { show: true, barWidth: 1, lineWidth: 20, align: "center" }})