$ ->
  if ($ 'form#update-cart').is('*')
    ($ 'form#update-cart a.delete').show().on 'click', (e) ->
      $(this).parents('.line-item').first().find('input.line_item_quantity').val 0
      $(this).parents('form').first().submit()
      e.preventDefault()
      return

  if $('#product-variants ul li').html() != undefined
    $('#product-variants ul li').on "click", ->
      $('#product-variants ul li img').removeClass('active')
      $(this).find('img').addClass('active')

      $('#product-price .selling').text($(this).data('price'))

      #$('#product-variants ul li .count-on-hand').text('')
      #$(this).find('.count-on-hand').text("Còn " + $(this).data('count_on_hand') + " SP")
      $('.count-on-hand').hide()
      $(this).find('.count-on-hand').show()
      $('#quantity').attr("max", $(this).data('count_on_hand'))
      $('#quantity').val(1)

    $.each $('#product-variants ul li'), (index, li) ->
      if $(li).find('img').hasClass("active")
        $('#product-price .selling').text($(this).data('price'))
        $('#quantity').attr("max", $(this).data('count_on_hand'))

  if $('#product-thumbnails').html() != undefined
    $('#product-thumbnails img').on "hover", ->
      $('#product-thumbnails li').removeClass('selected')
      $(this).parent().parent().addClass('selected')
      $('#main-image img').attr('src', $(this).data('image_url'))
