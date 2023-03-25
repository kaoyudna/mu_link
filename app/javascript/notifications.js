$(document).on('turbolinks:load', function () {

  $('.notification').on('click', function(e) {
    e.preventDefault();
    var notificationId = $(this).data('notification-id');
    $.ajax({
      url: '/notifications/' + notificationId,
      type: 'PATCH',
      success: function(response) {
        window.location.href = e.target.href;
      }
    });
  });

  window.addEventListener('pageshow',()=>{
	  if(window.performance.navigation.type==2) location.reload();
  });
});