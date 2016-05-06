// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-1.11.0.min
//= require jquery.form.js
//= require jquery-migrate-1.2.1.min
//= require jquery-ui/jquery-ui-1.10.3.custom.min
//= require bootstrap/js/bootstrap.min
//= require bootstrap-hover-dropdown/bootstrap-hover-dropdown.min
//= require jquery-slimscroll/jquery.slimscroll.min
//= require jquery.blockui.min
//= require jquery.cokie.min
//= require uniform/jquery.uniform.min
//= require bootstrap-switch/js/bootstrap-switch.min
//= require select2/select2.min
//= require datatables/media/js/jquery.dataTables.min
//= require datatables/plugins/bootstrap/dataTables.bootstrap
//= require flot/jquery.flot.min
//= require flot/jquery.flot.resize.min
//= require flot/jquery.flot.categories.min
//= require jquery.pulsate.min
//= require jquery.sparkline.min
//= require gritter/js/jquery.gritter
//= require metronic
//= require layout
//= require quick-sidebar
//= require index
//= require tasks
//= require table-managed
//= require jquery.validate.min
//= require additional-methods.min
//= require apprise-v2
//= require apprise-1.5.full
//= require markerwithlabel



function hudMsg(type, message, timeOut) {

    $('.hudmsg').remove();

    if (!timeOut) {
        timeOut = 3000;
    }

    var timeId = new Date().getTime();

    if (type != '' && message != '') {

        $('<div class="hudmsg ' + type + '" id="msg_' + timeId + '"><img src="/assets/msg_' + type + '.png" alt="" />' + message + '</div>').hide().appendTo('body').fadeIn();

        var timer = setTimeout(
            function () {
                $('.hudmsg#msg_' + timeId + '').fadeOut('slow', function () {
                    $(this).remove();
                });
            }, timeOut
        );
    }
}
