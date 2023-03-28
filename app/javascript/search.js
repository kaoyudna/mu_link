$(document).on('turbolinks:load', function () {
 
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