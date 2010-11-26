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
  $('.simpledialog').simpleDialog();
});

//  Kalender für Auswahl des Datums z.B. für Urlaubs-Einstellung
$(document).ready(function(){
  $('input.ui-datepicker').datepicker();
});

/*################################################################################################
##  The following methods are used for the choose of the membership.
##  In case of premium the user could select the period and the continuation of his membership.
/################################################################################################*/

var ids=new Array('user_premium_period_input', 'user_continue_membership_input');

function switchid(id){
	//hideallids();
	showdiv(id);
}

function hideallids(){
	//loop through the array and hide each element by id
	for (var i=0;i<ids.length;i++){
		hidediv(ids[i]);
	}
}

function hidediv(id) {
	//safe function to hide an element with a specified id
	if (document.getElementById) { // DOM3 = IE5, NS6
		document.getElementById(id).style.display = 'none';
	}
	else {
		if (document.layers) { // Netscape 4
			document.id.display = 'none';
		}
		else { // IE 4
			document.all.id.style.display = 'none';
		}
	}
}

function showdiv(id) {
	//safe function to show an element with a specified id

	if (document.getElementById) { // DOM3 = IE5, NS6
		document.getElementById(id).style.display = 'block';
	}
	else {
		if (document.layers) { // Netscape 4
			document.id.display = 'block';
		}
		else { // IE 4
			document.all.id.style.display = 'block';
		}
	}
}

// javascript:switchid('user_membership_true')
$(document).ready(function(){
  $('li.user_membership_true').click(function()
    {
      switchid('user_premium_period_input', 'user_continue_membership_input');
    })
});
//

//$('a.publish').onclick(confirm('Möchten sie den Inhalt wirklich veröffentlichen?'));

