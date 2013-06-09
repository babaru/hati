function query_report_procedure_status(url, report_id) {
  var status = 0;
  $.ajax({
      type: 'GET',
      url: url,
      success: function(result) {
        status = parseInt(result["queue_status"]);
        if(status == 1 || status == 2) {
          setTimeout('query_report_procedure_status(' + report_id + ')', 10000);
        } else {
          window.location.reload();
        }
      },
      complete: function() {

      }
    });
}
