$(document).on('turbolinks:load', function () {

  $('#tab-menu a').on('click', function(event) {
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#users_tab-menu a').on('click', function(event) {
    $("#users_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#groups_tab-menu a').on('click', function(event) {
    $("#groups_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

});


