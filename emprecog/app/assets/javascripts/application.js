// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require signature_pad
//= require Chart.min
//= require js.cookie
//= require jstz
//= require browser_timezone_rails/set_time_zone
//= require_tree .

// getting jquery working here: http://stackoverflow.com/questions/11216192/html-select-jquery-change-not-working
$(document).ready(function () {
  // get the data from the reporting route

  $.get("all_awards", function(data) {
      var thediv = $("#allChart");

    var myChart = new Chart(thediv, data);
  }, "json");

  // watch for dropdown changes to trigger chart loading
  $(".by_user_dropdown").change(function () {

    $.get("award_by_user", {id: $(this).val()}, function(data){
      console.log("Success!");

      console.log(data);
      var thediv = $("#byChart");


      var myChart = new Chart(thediv, data);

    }, "json");
  });

$(".user_awards_dropdown").change(function (){

  $.get("user_awards", {id: $(this).val()}, function(data){
    console.log("Success!");

    console.log(data);
    var thediv = $("#userChart");


    var myChart = new Chart(thediv, data);

  }, "json");
  });
});

