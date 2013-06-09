$(document).ready(function(){
  var cca = $('.char_count_alert');
  $('.control-group.text label').after(cca);
  $('textarea').NobleCount('.char_count_alert', {
    on_negative: 'label-warning',
    on_positive: 'label-success',
    max_chars: 140
  });
});
