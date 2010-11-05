// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $('input[autocomplete]').each(function(i){
    $(this).autocomplete({
      source: $(this).attr('autocomplete')
      });
  });
});

$(document).ready(function () {
  $('.simpledialog').simpleDialog();
});

$(function () {
        $('#alert').click(function () {
          alert('Hello, world!');
          return false;
        })
      });
