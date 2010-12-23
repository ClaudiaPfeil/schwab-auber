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
      $("#user_continue_membership_true").attr("checked", "checked");
      $("#user_membership_true").attr("checked", "checked");
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

  // Erstellen Kleiderpaket
  $('#package_next_size_input').hide();
  $('#package_shirts_input').hide();
  $('#package_blouses_input').hide();
  $('#package_jackets_input').hide();
  $('#package_jeans_input').hide();
  $('#package_dresses_input').hide();
  $('#package_basics_input').hide();

  // Anzeigen, wenn Premium Mitgliedschaft angeklickt ist
  $('#user_membership_true').click(function (){
    $('#user_continue_membership_input').show();
    $("#user_continue_membership_true").attr("checked", "checked");
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

  // PayPal-Bankverbindung ausgewählt, dann Bankverbindung verstecken
  $('#payment_kind_2').click(function (){
    $('#prepayment').hide();
    $('#payment_PM').val("PAYPAL");
    $('#payment_TXTOKEN').val("INIT");
  })

  // Kredit/Visa-Card ausgewählt, dann Bankverbindung verstecken
  $('#payment_kind_3').click(function (){ 
    $('#payment_PM_input').show();
    $('#payment_PM').val("CreditCard");
    $('#payment_BRAND').val("VISA");
    $('#payment_WIN3DS').val("POPUP");
    $('#payment_PMLIST').val("VISA;MasterCard");
    $('#payment_PMLISTTYPE').val("2");
  })

  $('#package_size').click(function (){
    $('#package_next_size_input').show();
    var next_size = parseInt(document.getElementById('package_size').value)
    next_size = next_size + 2
    $("#package_next_size").val(next_size)
  })

  $('#package_amount_clothes').click(function () {
    var amount = parseInt(document.getElementById('package_amount_clothes').value)

    if (amount < 10) {
      alert("Ist die Box wirklich voll?");
    }

  })

  // Erstellen Kleiderpaket
  $('#package_kind_shirts__tops').click(function () {
    
    if($('#package_kind_shirts__tops').attr("checked")){
      $('#package_shirts_input').slideDown();
    }
    else
    {
      $('#package_shirts_input').slideUp();
    }
  })

   $('#package_kind_blusen__hemden').click(function () {
     if($('#package_kind_blusen__hemden').attr("checked")){
       $('#package_blouses_input').slideDown();
     }else{
       $('#package_blouses_input').slideUp();
     }
    
  })

  $('#package_kind_jacken').click(function () {
    if($('#package_kind_jacken').attr("checked")){
      $('#package_jackets_input').slideDown();
    }else{
      $('#package_jackets_input').slideUp();
    }
  })

  $('#package_kind_jeans').click(function () {
    if($('#package_kind_jeans').attr("checked")){
      $('#package_jeans_input').slideDown();
    }else{
      $('#package_jeans_input').slideUp();
    }
  })

  $('#package_kind_kleider__röcke').click(function () {
    if($('#package_kind_kleider__röcke').attr("checked")){
      $('#package_dresses_input').slideDown();
    }else{
      $('#package_dresses_input').slideUp();
    }
  })

  $('#package_kind_erstausstattung').click(function () {
    if($('#package_kind_erstausstattung').attr("checked")){
      $('#package_basics_input').slideDown();
    }else{
      $('#package_basics_input').slideUp();
    }
  })
  
})

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

jQuery(function($){
        $.datepicker.regional['de'] = {clearText: 'löschen', clearStatus: 'aktuelles Datum löschen',
                closeText: 'schließen', closeStatus: 'ohne Änderungen schließen',
                prevText: '&#x3c;zurück', prevStatus: 'letzten Monat zeigen',
                nextText: 'Vor&#x3e;', nextStatus: 'nächsten Monat zeigen',
                currentText: 'heute', currentStatus: '',
                monthNames: ['Januar','Februar','März','April','Mai','Juni',
                'Juli','August','September','Oktober','November','Dezember'],
                monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
                'Jul','Aug','Sep','Okt','Nov','Dez'],
                monthStatus: 'anderen Monat anzeigen', yearStatus: 'anderes Jahr anzeigen',
                weekHeader: 'Wo', weekStatus: 'Woche des Monats',
                dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
                dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
                dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
                dayStatus: 'Setze DD als ersten Wochentag', dateStatus: 'Wähle D, M d',
                dateFormat: 'dd.mm.yy', firstDay: 1,
                initStatus: 'Wähle ein Datum', isRTL: false};
        $.datepicker.setDefaults($.datepicker.regional['de']);
});