$(document).ready(function(){
    // $('#refresh_data_dialog').modal('show');
    $('.open_refresh_data_panel_button').click(function(){
        $('#refresh_data_panel').show();
    })
    $('#refresh_data_cancel_button').click(function() {
        $('#refresh_data_panel').hide();
    });

    $('.comment_review_positive_button').click(function() {
        review_comment($(this), "positive");
    });

    $('.comment_review_negative_button').click(function() {
        review_comment($(this), "negative");
    });

    $('.comment_review_neutral_button').click(function() {
        review_comment($(this), "neutral");
    });
});

function review_comment(btn, review) {
    btn.parent().hide();
    btn.parent().parent().append('<div class="progress progress-striped active small" style="width:90px;"><div class="bar" style="width: 100%;"></div></div>');

    var weibo_comment_id = btn.siblings('span.weibo_comment_id').text();

    $.ajax({
      type: 'POST',
      url: '/weibo_comments/' + weibo_comment_id + '/review.json', 
      data: {
        review: review
      },
      success: function(result) {
        if(result["success"] == true) {
            var td = btn.closest('td').siblings('td:nth-child(4)');
            td.children().remove();
            if(review == 'positive') {
                td.append('<span class="label label-success">' + review + '</span>');
            } else if (review == 'negative') {
                td.append('<span class="label label-important">' + review + '</span>');
            }
            // } else {
            //     td.append('<span class="label">' + review + '</span>');
            // }
        }
      },
      complete: function() {
        btn.parent().siblings('.progress').remove();
        btn.parent().show();
      }
    });
}