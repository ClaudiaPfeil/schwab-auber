$(function() {
  // init tabs
  $(".tabs").tabs();



  // init flat folder for formtastic forms with class flat_folder
  $('form.formtastic.flat_folder fieldset.inputs:not(.discard_flat_folder_control) > legend').click(function(){
    $($(this).parent().get(0)).toggleClass('hidden');
  });

  // flat folder toggle control
  $('span.flat_folder_control').click(function(){
    var hidden = $(this).hasClass('hidden');
    $(this).toggleClass('hidden');
    $('form.formtastic.flat_folder fieldset.inputs:not(.discard_flat_folder_control) > legend').each(function(){
      if(hidden) {
        $($(this).parent().get(0)).removeClass('hidden')
        ;
      } else {
        $($(this).parent().get(0)).addClass('hidden');
      };
    });
  });



  // init global ajax loading indicator
  $("#ajax_loading_indicator").ajaxStart(function(){
     $(this).show();
   }).ajaxStop(function(){
     $(this).hide();
   });



  // init system messages
  $('.system_message').each(function(e){
    var $el = $(this);
    $el.hide();
    if($el.hasClass('alert_message')) {
      $.jGrowl( $el.html(), { theme: 'alert', sticky: true } );
    } else {
      $.jGrowl( $el.html());
    }
  });



  // init search forms, , input[type=search]
  $('.list_table_widget .search_form input:not(.active)').focus(function(){
    this.value = '';
  }).blur(function(){
    this.value = $(this).attr('data-inline-label');
  });



  // init linked list table rows
  $('table.list_table_widget tbody tr').live('dblclick', function(event){
    if (!event.srcElement.href) { // clicks to normal anchors should pass
      var click_path = $(this).find('td:first a.edit_record_link,td:first a.show_record_link').attr('href');
      if(click_path) {
        window.location.href = click_path;
      }
    }
  });



  // init autocompleters
  $(".autocompleter_field").each(function(){
    var autocomple_source_path = $(this).attr('data-autocomplete-source-path');
    var after_select_destination_path = $(this).attr('after-select-destination-path');

    $(this).autocomplete({
      source: autocomple_source_path,
      dataType: 'json',
      minLength: 1,
      select: function(e, ui) {
        $.ajax({
          url: after_select_destination_path,
          data: { id: ui.item.value },
          dataType: 'script'
        });
      }
    });
  });



  // init tooltips
  // http://flowplayer.org/
  $('a[title]').tooltip({
    predelay: 1000,
    opacity: 0.9
  }).dynamic();




  // i18n for datepicker
  $.datepicker.regional['de'] = {
    closeText: 'schließen',
    prevText: '&#x3c;zurück',
    nextText: 'Vor&#x3e;',
    currentText: 'heute',
    monthNames: ['Januar','Februar','März','April','Mai','Juni',
    'Juli','August','September','Oktober','November','Dezember'],
    monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
    'Jul','Aug','Sep','Okt','Nov','Dez'],
    dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
    dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
    dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
    weekHeader: 'Wo',
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''};
  $.datepicker.setDefaults($.datepicker.regional['de']);

  // init datepickers
  $('input.ui-datepicker').datepicker();
});


// $("a[title]").tooltip({
//
//    // tweak the position
//    offset: [10, 2],
//
//    // use the "slide" effect
//    effect: 'slide'
//
// // add dynamic plugin with optional configuration for bottom edge
// }).dynamic({ bottom: { direction: 'up', bounce: true } });
