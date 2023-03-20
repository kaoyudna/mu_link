$(document).on('turbolinks:load', function () {
  $('.menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').fadeToggle();
    event.preventDefault();
  });

  $('#tab-menu a').on('click', function(event) {
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#tab-menu form').on('submit', function(event) {
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#users_tab-menu a').on('click', function(event) {
    $("#users_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#users_tab-menu form').on('submit', function(event) {
    $("#users_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#groups_tab-menu a').on('click', function(event) {
    $("#groups_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#groups_tab-menu form').on('submit', function(event) {
    $("#groups_tab-menu .active").removeClass("active");
    $(this).addClass("active");
  });

  $('#word').on('input', function() {
    $("#groups_tab-menu .active").removeClass("active");
    $("#tab-menu .active").removeClass("active");
    $("#users_tab-menu .active").removeClass("active");
    $.get($('#search-form').attr('action'), $('#search-form').serialize(), null, 'script');
  });

  $('#search-form').on('ajax:success', function(event) {
    $('#groups_index').html(event.detail[2].responseText);
  });

  $('#search-form').on('ajax:success', function(event) {
    $('#posts_index').html(event.detail[2].responseText);
  });

  $('#search-form').on('ajax:success', function(event) {
    $('#users_index').html(event.detail[2].responseText);
  });
});

