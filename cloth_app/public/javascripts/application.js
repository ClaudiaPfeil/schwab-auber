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

$(document).ready(function(){
  $('input.ui-datepicker').datepicker();
});


//

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

