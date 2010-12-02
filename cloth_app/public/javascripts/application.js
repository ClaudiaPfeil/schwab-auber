// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Automatische Vervollständigung der Suche
$(document).ready(function(){
  $('input[autocomplete]').each(function(i){
    $(this).autocomplete({
      source: $(this).attr('autocomplete')
      });
  });
});

//  Dialog-Fenster z.B. für Bestätigung der Regeln beim Erstellen eines Kleiderpakets
$(document).ready(function () {
  $('.simpledialog').simpleDialog({
    show: "blind",
		hide: "explode"
  });
});

//  Kalender für Auswahl des Datums z.B. für Urlaubs-Einstellung
$(document).ready(function(){
  $('input.ui-datepicker').datepicker();
});

//  Auf- und Zuklappen der Formular-Elemente
$(document).ready(function() {
		$( "#accordion" ).accordion({
      autoHeight: false,
			navigation: true
    });
});


/*################################################################################################
##  The following methods are used for the choose of the membership.
##  In case of premium the user could select the period and the continuation of his membership.
/################################################################################################*/

$(document).ready(function(){
  $('#user_continue_membership_input').hide();
  $('#user_premium_period_input').hide();
})

$(document).ready(function(){
  $('#user_membership_true').click(function (){
    $('#user_continue_membership_input').show();
  })

  $('#user_membership_true').click(function (){
    $('#user_premium_period_input').show();
  })
})

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

