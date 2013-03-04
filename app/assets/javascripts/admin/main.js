$(document).ready(function(){
    //$('[rel=tooltip]').tooltip({title: "test me", placement: 'bottom', trigger: 'manual'});
    $('[rel=tooltip]').tipsy({html: true, gravity: 's', fade: true});
    $.ajaxSetup({
      beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      }
    });
});
