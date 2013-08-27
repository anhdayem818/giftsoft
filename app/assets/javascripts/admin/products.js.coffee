$(document).ready ()->
  $(".product-image").click (event)->
    event.preventDefault()
    tinymce.execCommand('mceInsertContent', false, '<img id="__mce_tmp" src="' + $('img', @).attr('origin-src') + '" />', { skip_undo: 1 })
  $('.resume-resource').click (event) ->
    el = $(this);
    $.ajax({
      type: 'POST',
      url: $(this).attr("href"),
      data: {
        _method: 'post',
        authenticity_token: AUTH_TOKEN
      },
      dataType: 'script',
      success: (response)->
        el.parents("td").html(response.responseText);
      ,
      error: (response, textStatus, errorThrown)->
        el.parents("td").html(response.responseText);
        #show_flash_error(response.responseText);
    });
    false