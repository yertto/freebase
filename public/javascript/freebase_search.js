/*
var LOCATION_TYPE = '/location/location';
*/


change_topic = function(type, topic){
  $('#search_topic').suggest({"type": type, "type_strict": "all"});
  $('#search_topic').val(topic).data("suggest").textchange();
  $('#search_topic').bind('fb-select', function(e, search_topic){
    $('#search_result').html(
      'Result:<blockquote>{"<a href="http://freebase.com/view' + search_topic.id + '">' + search_topic.id + '</a>": "' + search_topic.name + '"}</blockquote>'
    );
  });
  $('#search_topic').focus();
};


$(document).ready(function(){
  $('#search_domain').suggest({'type': '/type/domain', 'type_strict': 'all'});
  $('#search_type'  ).suggest({'type': '/type/type'  , 'type_strict': 'all'});
  $('#search_topic' ).suggest();

  $('#search_domain').bind('fb-select', function(e, search_domain){
    $('#search_type').suggest({'type': '/type/type', 'type_strict': 'all', 'mql_filter': [{'/type/type/domain': search_domain.id}]});
    $('#search_type').val('').data('suggest').textchange();
    $('#search_type').bind('fb-select', function(e, search_type){
      change_topic(search_type.id, '');
    });
    $('#search_type').focus();
  });

  $('a[class=suggest_example]').bind('click', function(){
    $('#search_domain').val(this.getAttribute('data-domain_name'));
    $('#search_type'  ).val(this.getAttribute('data-type_name'));
    change_topic(this.getAttribute('data-type'), this.getAttribute('data-topic'));
    return false;
  });
});


