$(document).on('turbolinks:load', function () {
  $('.menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').fadeToggle();
    event.preventDefault();
  });
});


$(document).on('turbolinks:load', function () {
  $('#tab-menu a').on('click', function(event) {
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    event.preventDefault();
  });
});

$(document).on('turbolinks:load', function () {
  $('#users_tab-menu a').on('click', function(event) {
    $("#users_tab-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    event.preventDefault();
  });
});
