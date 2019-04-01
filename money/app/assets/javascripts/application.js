// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require activestorage
// require jquery
// require jquery.ui.core
// require jauery.ui.datepicker
// require jquery_ujs
//= require turbolinks
//= require_tree .
//

var data = {'data-format': 'yyyy-MM-dd' };
$(function(){
    beforeShow: function() {
        setTimeout(function(){
            $('.ui-datepicker').css('z-index', 99999999999999);
        }, 0);
    }
    $('.datepicker').attr(data);
    $('.datepicker').datetimepicker();
});