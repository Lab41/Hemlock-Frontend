// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require jquery.tokeninput
//= require twitter/bootstrap
//= require bootstrap
//= require_tree .
//= require bootstrap-wysihtml5
//= require turbolinks
//= require jquery.turbolinks
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= tipsy
//= d3.v3.min

$('document').ready(function() {
  loadBootStrap();
});

$(window).bind('page:load', function() {
  // stub
})

/* Bootstrap style pagination control */
var loadBootStrap;
var loadBootStrap = function() {
  loadDataTable();
};

var loadDataTable;
loadDataTable = function() {
  $('.datatable').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 50,
    "aLengthMenu": [[1, 5, 10, 25, 50, -1], [1, 5, 10, 25, 50, "All"]]
  });
};

var reloadDataTable;
reloadDataTable = function() {
  $('.search-datatable').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 50,
    "aLengthMenu": [[1, 5, 10, 25, 50, -1], [1, 5, 10, 25, 50, "All"]]
  });
};

$(".navbar-inner a").on("click", function(e){  
    $(".nav a").removeClass("active");
    $(this).addClass("active");
});
