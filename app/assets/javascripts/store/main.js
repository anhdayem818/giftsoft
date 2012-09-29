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
    $('#products .add-to-cart').click(function() {
        var product = $(this).closest('[data-hook="products_list_item"]');
        var name = product.children('[itemprop="name"]').attr('title');
        var variant_id = product.attr('variant_id');
        addToCart($(this), variant_id);
    //alert($(this).attr('price'));
    });
    $('.checkout.disabled').livequery('click', function(e){
       alert('Quý khách vui lòng mua đủ 200.000đ, Xin cảm ơn!');
       e.preventDefault();
    });

    $('#cart-details a.delete').livequery('click', function(e) {
        
        //var items = '{id: }';
        //$.post("/orders/populate", $.parseJSON(items));
        //var obj = jQuery.parseJSON(items);
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
                var title = "Xem chi tiết đơn hàng tại đây";
                $("#cart-dropdown").tooltip({title: title, placement: 'bottom', trigger: 'manual'});
                $("#cart-dropdown").tooltip('show');
                $(".tooltip.fade.bottom.in").css("position", "fixed").css("top", "50px");
            }
        });
        //$("#cart-checkout").removeClass("disabled");
        
    }
})
