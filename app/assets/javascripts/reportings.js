$(document).ready(function() {
  // $('.reporting-sections-nav').scrollspy();
  // $('.reporting-sections-nav').affix();

  $('.btn-generate-reporting').click(function () {
    var btn = $(this);
    var reporting_id = btn.children("span").text();
    btn.button('loading'); 

    $.ajax({
      type: 'POST',
      url: '/reporting/generate.json', 
      data: {
        id: reporting_id
      },
      success: function(result) {
        // window.location.href = result["url"];
      },
      complete: function() {
        btn.button('reset');
      }
    });
  });

  $('.btn-capture-snapshot').click(function () {
    var btn = $(this);
    var reporting_id = btn.children("span").text();
    btn.button('loading'); 

    $.ajax({
      type: 'POST',
      url: '/reporting/capture.json', 
      data: {
        id: reporting_id
      },
      success: function(result) {
        // window.location.href = result["url"];
      },
      complete: function() {
        btn.button('reset');
      }
    });
  });
});