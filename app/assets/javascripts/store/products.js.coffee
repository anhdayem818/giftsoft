$(document).ready ->
  if $("#products").size() != 0 && window.no_scroll == undefined
    $("#products-loading").show()
    $(window).scroll ->
      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 230) && $(window).scrollTop() <= ($(document).height() - $(window).height())
        page = (parseInt $("#products").attr("data-page")) + 1
        $("#products").attr("data-page", page)
        $.ajax
          url: '/?page=' + page
          type: 'GET'
          dataType : 'script'
