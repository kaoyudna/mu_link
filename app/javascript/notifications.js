$(document).on('turbolinks:load', function () {

  $('a.text-info').on('click', function(e) {
    e.preventDefault();
    var notificationId = $(this).data('notification-id');
    $.ajax({
      url: '/notifications/' + notificationId + '/mark_as_checked',
      type: 'PATCH',
      success: function(response) {
        window.location.href = e.target.href;
      }
    });
  });

});