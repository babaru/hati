(function($){
    $.fn.extend({
        //plugin name - missionLoader
        missionLoader: function(options) {

            //Settings list and the default values
            var defaults = {
                state: 'head',
                url: '/missions/',
                error: null,
                loading: 'LOADING',
                mission_id: null
            };

            var options = $.extend(defaults, options);

            return this.each(function() {

                var obj = $(this);
                var wrap = $('<div />').addClass("coin-button pull-left");
                wrap.insertBefore(obj);
                wrap.append(obj);
                wrap.width(obj.width() + 30);
                obj.html(obj.html() + ' <span class="badge badge-important" rel="tooltip" title="' + options.error + '">!</span>');

                var progress_wrap = $('<div />').addClass("progress progress-striped progress-warning active");
                wrap.append(progress_wrap);
                progress_wrap.append($('<div />').addClass("bar").css("width", '100%').css("line-height", obj.height() + "px").text(options.loading));
                progress_wrap.height(obj.height() + 2);

                progress_wrap.hide();
                if(options.error == null) {
                    $('.badge', obj).hide();
                }

                if(options.state == 'loading') {
                    progress_wrap.show();
                    obj.hide();
                }

                $(".badge", obj).tooltip();

                check_mission_state(wrap, options);
                console.log("setTimeout");
                setTimeout(check_mission_state, 5000, wrap, options);
            });
        }
    });
})(jQuery);

function check_mission_state(wrap, options) {
    var progress_wrap = $('.progress', wrap);
    var obj = $('.button', wrap);
    $.get(options.url + options.mission_id + '.json', function(data) {
        console.log("loaded mission: " + options.mission_id);
        if(data.status == 4) {
            progress_wrap.hide();
            obj.show();
        }
        if(data.status == 2) {
            progress_wrap.show();
            obj.hide();
            setTimeout(check_mission_state, 5000, wrap, options);
        }
        if(data.status == 3) {
            progress_wrap.hide();
            obj.show();
        }
        if(data.status == 1) {
            progress_wrap.show();
            obj.hide();
            setTimeout(check_mission_state, 5000, wrap, options);
        }
    });
}
