//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require bootstrap
//= require wice_grid
//= require jquery.NobleCount.min
//= require bootstrap-editable.min
//= require bootstrap-datetimepicker.min
//= require bootstrap-datepicker
//= require mission_loader

$(document).ready(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();

  $('.dropdown-toggle').dropdown();

  $('.date-time-picker').datetimepicker({
    format: 'yyyy-MM-dd hh:mm:ss'
  });

  $('.date-picker').datetimepicker({
    format: 'yyyy-MM-dd',
    pickTime: false
  });

  // $.fn.editable.defaults.mode = 'inline';
});
