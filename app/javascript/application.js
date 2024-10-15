// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function(){
  $('.tabs li a').on('click', function(e){
    e.preventDefault();
    $('.tabs li').removeClass('active');
    $(this).parent().addClass('active');

    var target = $(this).attr('href');
    $('.tab-pane').removeClass('active');
    $(target).addClass('active');
  });
});
