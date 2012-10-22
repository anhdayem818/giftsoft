$(document).ready ()->
  $(".product-image").click (event)->
    event.preventDefault()
    tinymce.execCommand('mceInsertContent', false, '<img id="__mce_tmp" src="' + $('img', @).attr('origin-src') + '" />', { skip_undo: 1 })