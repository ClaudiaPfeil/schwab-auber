// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $('input[autocomplete]').each(function(i){
    $(this).autocomplete({
      source: $(this).attr('autocomplete')
      });
  });
});

//$(function() {
//    $('#package_submit').simpleDialog();
//});

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

