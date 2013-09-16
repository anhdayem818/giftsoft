$(document).ready(function() {
    $.ajaxSetup({
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    });
    $.fn.exists = function () {
        return this.length !== 0;
    }
    $('.carousel').carousel();

    $('.checkout.disabled').livequery('click', function(e){
       alert('Quý khách vui lòng mua đủ ' + $(this).attr('min_total') + 'đ , Xin cảm ơn!');
       e.preventDefault();
    });

    $('#cart-details a.delete').livequery('click', function(e) {

        //var items = '{id: }';
        //$.post("/orders/populate", $.parseJSON(items));
        //var obj = jQuery.parseJSON(items);
        restore_quantity = parseInt($(this).parents('td').prev().html());
        variant_id = parseInt($(this).parents('tr').attr('variant_id'));
        if ($('#product-variants').html() != undefined) {
          $.each($('#product-variants ul li'), function(index, li) {
            li_variant_id = parseInt($(this).attr('variant_id'));
            if (li_variant_id == variant_id){
              current_quantity = parseInt($(this).attr('data-count_on_hand')) + restore_quantity;
              $(this).attr('data-count_on_hand', current_quantity);
              if ($(this).find('img').hasClass('active')){
                $(this).find('.count-on-hand .quantity').text("còn " + current_quantity + " sp");
                $('#quantity').attr("max", current_quantity);
                $('#quantity').attr("min", 1);
                $('#quantity').val(1);
              }
            }
          });
        } else if ($('[data-hook="product_left_part"]').html != undefined) {
          current_quantity = parseInt($('[data-hook="product_left_part"]').attr('count_on_hand')) + restore_quantity;
          $('[data-hook="product_left_part"]').attr('count_on_hand', current_quantity);
          $('div.add-to-cart input').attr("max", current_quantity);
          $('div.add-to-cart input').attr("min", 1);
          $('div.add-to-cart input').val(1);
        }

        var id = $(this).attr("item_id");
        $.ajax({
            type: "DELETE",
            //the url where you want to sent the userName and password to
            url: '/spree/line_items/' + id,
            dataType: 'text',
            //json object to sent to the authentication url
            success: function (data) {
                $("#cart-details").replaceWith(data);
            }
        });
        $("#cart-checkout").removeClass("disabled");
        return false;
    })
    $(".search-query").product_autocomplete();
})

function addToCart(object, variant_id) {
  var original_html = object.html();
  object.html("Đang xử lý");
  object.addClass("disabled");
  var items = '{"variants": {"' + variant_id + '": "1"}}';
  //$.post("/orders/populate", $.parseJSON(items));
  var obj = jQuery.parseJSON(items);
  $.ajax({
    type: "POST",
    //the url where you want to sent the userName and password to
    url: '/orders/populate',
    dataType: 'text',
    //json object to sent to the authentication url
    data: obj,
    success: function (data) {
      $("#cart-details").replaceWith(data);
      object.html(original_html);
      object.removeClass("disabled");
      $("#cart-dropdown").effect("highlight", {color:"#22DD66"}, 3000);
      //var title = "Xem chi tiết đơn hàng tại đây";
      //$("#cart-dropdown").tooltip({title: title, placement: 'bottom', trigger: 'manual'});
      //$("#cart-dropdown").tooltip('show');
      //$(".tooltip.fade.bottom.in").css("position", "fixed").css("top", "50px");
    }
  });
  //$("#cart-checkout").removeClass("disabled");

}

function build_events_add_to_cart(){
  $('#products .add-to-cart').unbind("click");
  $('#products .add-to-cart').click(function() {
    var product = $(this).closest('[data-hook="products_list_item"]');
    var name = product.children('[itemprop="name"]').attr('title');
    var variant_id = product.attr('variant_id');
    addToCart($(this), variant_id);
    //alert($(this).attr('price'));
  });
}
