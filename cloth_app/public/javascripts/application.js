// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $('input[autocomplete]').each(function(i){
    $(this).autocomplete({
      source: $(this).attr('autocomplete')
      });
  });
});

$.prompt('Möchten sie das neue Kleiderpacket wirklich erstellen?',{buttons: { Ja: true, Abbrechen: false }});