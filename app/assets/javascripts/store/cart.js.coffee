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

      $(this).find('.count-on-hand .quantity').text("còn " + $(this).attr('data-count_on_hand') + " sp")
      $('#quantity').attr("max", $(this).attr('data-count_on_hand'))

      count_on_hand = parseInt $(this).attr('data-count_on_hand')
      if count_on_hand <= 0
        $('#quantity').val(0)
        $('#quantity').attr("min", 0)
      else
        $('#quantity').attr("min", 1)
        $('#quantity').val(1)

      $('.count-on-hand').hide()
      $(this).find('.count-on-hand').show()


    $.each $('#product-variants ul li'), (index, li) ->
      if $(li).find('img').hasClass("active")
        $('#product-price .selling').text($(this).data('price'))
        $('#quantity').attr("max", $(this).attr('data-count_on_hand') )
        count_on_hand = parseInt $(this).attr('data-count_on_hand')
        if count_on_hand <= 0
          $('#quantity').attr("min", 0)
          $('#quantity').val(0)

  if $('#product-thumbnails').html() != undefined
    $('#product-thumbnails img').on "hover", ->
      $('#product-thumbnails li').removeClass('selected')
      $(this).parent().parent().addClass('selected')
      $('#main-image img').attr('src', $(this).data('image_url'))

  $('#inside-product-cart-form #add-to-cart-button').on "click", (e) ->
    e.preventDefault()
    variant_id = -1
    quantity = parseInt $('div.add-to-cart input').val()
    if $('#product-variants').html() != undefined
      $.each $('#product-variants input'), (index, el) ->
        if $(el).is(':checked')
          variant_id = parseInt $(el).val()
    if variant_id == -1
      variant_id = parseInt $('[data-hook="product_left_part"]').attr('variant_id')
    addToCart($(this), variant_id, quantity)
    false

addToCart = (object, variant_id, quantity) ->
  original_html = object.html()
  object.html "Đang xử lý"
  object.addClass "disabled"
  items = "{\"variants\": {\"" + variant_id + "\": \"" + quantity + "\"}}"

  #$.post("/orders/populate", $.parseJSON(items));
  obj = jQuery.parseJSON(items)
  $.ajax
    type: "POST"

    #the url where you want to sent the userName and password to
    url: "/orders/populate"
    dataType: "text"

    #json object to sent to the authentication url
    data: obj
    success: (data) ->
      $("#cart-details").replaceWith data
      object.html original_html
      object.removeClass "disabled"
      $("#cart-dropdown").effect "highlight",
        color: "#22DD66"
      , 3000

      if $('#product-variants').html() != undefined
        $.each $('#product-variants input'), (index, el) ->
          if $(el).is(':checked')
            current_quantity = $(el).parent().attr('data-count_on_hand') - quantity
            li = $(el).parent()
            li.attr('data-count_on_hand', current_quantity)
            li.find('.count-on-hand .quantity').text("Còn " + current_quantity + " sản phẩm")
            $('#quantity').val(current_quantity)
            $('#quantity').attr("max", current_quantity)
            if current_quantity <= 0
              $('#quantity').attr("min", 0)
      else
        current_quantity = parseInt $('[data-hook="product_left_part"]').attr('count_on_hand') - quantity
        $('[data-hook="product_left_part"]').attr('count_on_hand', current_quantity)
        $('div.add-to-cart input').val(current_quantity)
        $('div.add-to-cart input').attr("max", current_quantity)
        if current_quantity == 0
          $('div.add-to-cart input').attr("min", 0)
