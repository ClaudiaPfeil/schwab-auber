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

//  Dialog-Fenster mit Click-Event für das Upgrade der Mitgliedschaft
$(document).ready(function () {
  $('.upgrade').simpleDialog({
    show: "blind",
		hide: "explode",
    open: function(){
      // Anzeigen, wenn Premium Mitgliedschaft angeklickt ist 
      $('#user_continue_membership_input').show();
      $('#user_premium_period_input').show();
    },
    height: 400
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
  // standardmäßig Periode und Verlängerung nicht anzeigen
  $('#user_continue_membership_input').hide();
  $('#user_premium_period_input').hide();

  // Anzeigen, wenn Premium Mitgliedschaft angeklickt ist
  $('#user_membership_true').click(function (){
    $('#user_continue_membership_input').show();
  })

  $('#user_membership_true').click(function (){
    $('#user_premium_period_input').show();
  })

  // Verstecken, wenn Basis Mitgliedschaft angeklickt ist
  $('#user_membership_false').click(function (){
    $('#user_continue_membership_input').hide();
  })

  $('#user_membership_false').click(function (){
    $('#user_premium_period_input').hide();
  })
  
  // Bankverbindung anzeigen, wenn Vorauskasse als Zahlungsmethode ausgewählt ist
  $('#payment_kind_1').click(function (){
    $('#prepayment').show();
  })

  // Bankverbindung verstecken, wenn nicht Vorauskasse als Zahlungsmethode ausgewählt ist
  $('#payment_kind_2').click(function (){
    $('#prepayment').hide();
  })

  $('#payment_kind_3').click(function (){
    $('#prepayment').hide();
  })
})

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

