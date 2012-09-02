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
    $('.add-to-cart').click(function() {
        var product = $(this).closest('[data-hook="products_list_item"]');
        var name = product.children('[itemprop="name"]').attr('title');
        var variant_id = product.attr('variant_id');
        addToCart(name, variant_id);
    //alert($(this).attr('price'));
    });
    $('#cart-details a.delete').live('click', function(e) {
        
        //var items = '{id: }';
        //$.post("/orders/populate", $.parseJSON(items));
        //var obj = jQuery.parseJSON(items);
        var id = $(this).attr("item_id");
        $.ajax({
            type: "DELETE",
            //the url where you want to sent the userName and password to
            url: '/line_items/' + id,
            dataType: 'text',
            //json object to sent to the authentication url
            success: function (data) {
                $("#cart-details").replaceWith(data);
            }
        });
        $("#cart-checkout").removeClass("disabled");
        return false;
    })
    function addToCart(name, variant_id) {
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
            }
        });
        $("#cart-checkout").removeClass("disabled");
        
    }
})
