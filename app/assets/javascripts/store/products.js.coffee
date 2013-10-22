$(document).ready ->
  if $("[data-hook='homepage_products']").find("#products").size() != 0 && window.no_scroll == undefined
    if ($("[data-hook='homepage_products']").find("#products").position().top + $("[data-hook='homepage_products']").find("#products").height()) > $(window).height()
      $("#products-loading").show()
    $(window).scroll ->
      if $(window).scrollTop() >= ($("[data-hook='homepage_products']").find("#products").position().top + $("[data-hook='homepage_products']").find("#products").height()) - 574
#      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 230) && $(window).scrollTop() <= ($(document).height() - $(window).height())
        page = (parseInt $("#products").attr("data-page")) + 1
        $("#products").attr("data-page", page)
        $.ajax
          url: '/?page=' + page
          type: 'GET'
          dataType : 'script'

  if $("[data-hook='taxon_products']").find("#products").size() != 0 && window.no_scroll == undefined
    if ($("[data-hook='taxon_products']").find("#products").position().top + $("[data-hook='taxon_products']").find("#products").height()) > $(window).height()
      $("#products-loading").show()
    $(window).scroll ->
      if $(window).scrollTop() >= ($("[data-hook='taxon_products']").find("#products").position().top + $("[data-hook='taxon_products']").find("#products").height()) - 574
#      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 230) && $(window).scrollTop() <= ($(document).height() - $(window).height())
        page = (parseInt $("#products").attr("data-page")) + 1
        $("#products").attr("data-page", page)
        $.ajax
          url: location.pathname + '?page=' + page
          type: 'GET'
          dataType : 'script'

  $('#products .clone.active').live 'click', (e) ->
    $this = $(this)
    $this.attr('disabled', 'disabled').removeClass('active')
    $.ajax
      dataType: 'json'
      url: '/phukienso_products/clone'
      type: 'POST'
      data: {id: $this.attr('data-id')}
      success: (data) ->
        if data.result == 'success'
          $this.text('Cloned').removeClass('btn-primary').addClass('disabled')
        else
          alert 'error'