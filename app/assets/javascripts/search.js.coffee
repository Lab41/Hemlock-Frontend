submitSearch = (data) ->
  $.post '/searches/ajax_load_results',
    query: $('#query').val();
  false
  
$(document).ready ->
  $('#search-submit').on 'click', submitSearch
  false
  
$(window).bind 'page:load', () ->
  $('#search-submit').on 'click', submitSearch
  false
