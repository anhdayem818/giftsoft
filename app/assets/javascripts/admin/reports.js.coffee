$(document).ready ()->
  $.plot($("#flot-placeholder"),
    [ report_data ], { lines: { show: true },
    points: { show: true },
    xaxis:{ mode: "time", timeformat: "%m/%d", tickSize: [1, "day"] }})