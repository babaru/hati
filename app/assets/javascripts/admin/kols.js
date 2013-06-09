$(document).ready(function() {
  $('#refresh-all-kols-btn').click(function () {
    var btn = $(this);
    btn.button('loading'); 

    var user_uids = new Array();
    $('input[name="g1[selected][]"]:checked').each(function(i) {
      user_uids[i] = $(this).val();
    });
    
    $.ajax({
      type: 'POST',
      url: '/admin/kols/refresh.json', 
      data: {
        uids: user_uids.join(",")
      },
      success: function(result) {
        if (result.length == 0) {
          // show_alert('success', '刷新成功', '');
        } else {
          // show_alert('error', '出现错误', result.length + '个KOL没有刷新成功。');
        }
      },
      complete: function() {
        btn.button('reset');

        $('input[name="g1[selected][]"]:checked').each(function(i) {
          $(this).attr("checked", false);
        });

        location.reload();
      }
    });
  });

  $('.price.edit').editable(modify_price, {
    submit: ' ',
    cancel: ' ',
    cssclass: 'editable'
  });
});

function show_alert (type, caption, message) {
    $("#alert-area").append($('<div class="msg-box alert alert-' + type + ' fade in"><button type="button" class="close" data-dismiss="alert">×</button><strong>' + caption + '</strong> ' + message + '</div>').hide());
    window.setTimeout(function() {$(".msg-box").alert('close');}, 2000);
    $(".msg-box").fadeIn('fast');
}

function ajax_modify(settings) {
  $.ajax({
    type: 'POST',
    url: settings.url,
    data: {
      price: settings.value,
      id: settings.id
    },
    success: function(data, textStatus, jqXHR) {

    },
    error: function(xhr, textStatus, errorThrown) {
      show_alert('error', '更新失败', errorThrown);
      settings.cancel();
    },
    complete: function(xhr, textStatus) {
      response = $.secureEvalJSON(xhr.responseText);
      if (response.success) {
        show_alert('success', '更新成功', '');
      }
      else {
        show_alert('error', '更新失败', response.error);
        settings.cancel();
      }
    }
  });
}

function modify_price(value, settings) {
  var origin_value = this.revert;
  var text_box = $(this);

  ajax_modify({
    url: '/admin/kols/modify_price.json',
    value: value,
    id: text_box.attr('id'),
    cancel: function () {
      text_box.html(origin_value);
    }
  });

  return value;
}
