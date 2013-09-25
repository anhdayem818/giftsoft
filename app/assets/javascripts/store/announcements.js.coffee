$(document).ready ->
  $('.delete-announcement').on "click", ->
    if confirm "Bạn có chắn chắn không?"
      id = $(this).data('id')
      object = $(this)
      $.ajax
        url: '/admin/announcements/' + id
        type: 'DELETE'
        success: (data) ->
          object.parents('.announcement').remove()
          if $('#announcements .announcement').length == 0
            $('#announcements').remove()

    false