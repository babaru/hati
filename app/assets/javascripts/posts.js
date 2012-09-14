$(document).ready(function() {
	$('a[rel="modal"]').click(function(){
		$('#image-modal img').attr('src', $(this).attr('data-image'));
		$('#image-modal').modal();
	});

    $('a.trigger_post').on('ajax:before', function(event, xhr, status) {
      $(this).closest('tr').find('.loading-icon').show();
      $('a[tooltip="true"]').tooltip('hide');
      $(this).button('loading');
    });
});

function trigger_immediately() {
    // $(this).button('loading');
    // var post_id = $('.post_id', $(this).parent().parent()).text();
    // var loading_icon = $('.loading-icon', $(this).parent().parent());
    // loading_icon.show();
    // $.ajax({
    //   type: 'POST',
    //   url: '/posts/trigger.json', 
    //   data: {
    //     id: post_id
    //   },
    //   success: function(result) {
    //     window.location.href = result["url"];
    //   },
    //   complete: function() {
    //     btn.button('reset');
    //   }
    // });
}