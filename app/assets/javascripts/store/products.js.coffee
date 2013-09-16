$(document).ready ->
  if $("[data-hook='homepage_products']").find("#products").size() != 0 && window.no_scroll == undefined
    $("#products-loading").show()
    $(window).scroll ->
      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 230) && $(window).scrollTop() <= ($(document).height() - $(window).height())
        page = (parseInt $("#products").attr("data-page")) + 1
        $("#products").attr("data-page", page)
        $.ajax
          url: '/?page=' + page
          type: 'GET'
          dataType : 'script'

  if $("[data-hook='taxon_products']").find("#products").size() != 0 && window.no_scroll == undefined
    $("#products-loading").show()
    $(window).scroll ->
      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 230) && $(window).scrollTop() <= ($(document).height() - $(window).height())
        page = (parseInt $("#products").attr("data-page")) + 1
        $("#products").attr("data-page", page)
        $.ajax
          url: location.pathname + '?page=' + page
          type: 'GET'
          dataType : 'script'
