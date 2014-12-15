$(document).ready ->
  $('#new_images_link').click (event) ->
    event.preventDefault()
    ($ this).hide()
    ($ '#images').html($("#images-template").html())

  $(document).on "click", "#submit-images", ->
    $("#images-section form").submit()
    return

  $(document).on "change", "#admin-input-images", ->
    $form_content = $("#images-section form .content")
    $form_content.html("")
    $.each $(this)[0].files, (index, file) ->
      $form_content.append($("#attachment-tempplate").html().replace(/index_array/g, index))
      $last_attachment = $form_content.find(".attachment").last()
      readImage($last_attachment, file)

      $("#images-section").find(".form-buttons").show()

  $(document).on "click", '#cancel_images', (event) ->
    event.preventDefault()
    ($ '#new_images_link').show()
    ($ '#images').html('')

readImage = (el, file) ->
  FR = new FileReader()
  FR.onload = (e) ->
    $(el).find(".image img").attr "src", e.target.result
    return

  FR.readAsDataURL file
  return

