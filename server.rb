#!/usr/local/bin/ruby -rrubygems
require 'sinatra'
require 'helpers'

MY_VERSION = File.open(File.dirname(__FILE__) + "/VERSION").read.strip


EXAMPLE_TYPES = {
  '/location/australian_state' => ['Australian State', '/location'     , 'Location'      ] ,
  '/location/us_county'        => ['US County'       , '/location'     , 'Location'      ] ,
  '/music/album'               => ['Musical Album'   , '/music'        , 'Music'         ] ,
  '/architecture/architect'    => ['Architect'       , '/architecture' , 'Architecture'  ] ,
  '/cricket/cricket_player'    => ['Cricket Player'  , '/cricket'      , 'Cricket'       ] ,
  '/food/beer'                 => ['Beer'            , '/food'         , 'Food & Drink'  ] ,
}
EXAMPLE_TYPE_IDS = EXAMPLE_TYPES.keys.sort

EXAMPLE_TOPICS = {
  '/location/australian_state' => 'Victoria'                  ,
  '/location/us_county'        => 'Orange County'             ,
  '/music/album'               => 'The Dark Side of the Moon' ,
  '/architecture/architect'    => 'Robin Boyd'                ,
  '/cricket/cricket_player'    => 'Sachin Tendulkar'          ,
  '/food/beer'                 => 'Crown Lager'               ,
}


get '/location/*/path/*' do
  #response.headers['Cache-Control'] = 'public, max-age=29030400'
  location_type = params[:splat][0]
  location_id = '/'+params[:splat][1]
  MapFetcher.fetch_path(location_id, location_type)
end

get '/search' do
  haml :search
end

get '/' do
  redirect '/search'
end



__END__


@@ _header


@@ search
%h1 Search Freebase
%p
  Search
  %a{:href=>"http://freebase.com"} Freebase
  for a Topic, filtered by the Type, from a specific Domain.
%p
  Example searches:
  %ul
    - EXAMPLE_TYPE_IDS.collect do |type_id|
      %li
        %a{:href=>'#', :class=>'suggest_example', :'data-domain_name'=>EXAMPLE_TYPES[type_id][2], :'data-type'=>type_id, :'data-type_name'=>EXAMPLE_TYPES[type_id][0], :'data-topic'=>EXAMPLE_TOPICS[type_id], :title=>"Search: #{EXAMPLE_TOPICS[type_id].inspect} (filtered by #{EXAMPLE_TYPES[type_id][0].inspect} type from the #{EXAMPLE_TYPES[type_id][2].inspect} domain)"}= EXAMPLE_TOPICS[type_id] 
%hr
Search:
%blockquote
  %form
    %table
      %tr
        %th Domain
        %td
          %input{:id=>"search_domain", :placeholder=>'Filter types by domain...', :type=>"text"}
      %tr
        %th Type
        %td
          %input{:id=>"search_type", :placeholder=>'Filter topics by type...', :type=>"text"}
      %tr
        %th Topic
        %td
          %input{:id=>"search_topic", :placeholder=>'Find topics...', :type=>"text"}
#search_result


@@ layout
%html
  %head
    %meta{"http-equiv" => "Content-Type", :content => "text/html; charset=utf-8"}
    %link(type="text/css" rel="stylesheet" href="http://freebaselibs.com/static/suggest/1.2.1/suggest.min.css")
    %link(type='text/css' rel ='stylesheet' href='/css/01.css' media='screen projection')
    %script(type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js")
    %script(type="text/javascript" src="http://freebaselibs.com/static/suggest/1.2.1/suggest.min.js")
  %body
    = haml :_header
    = yield
    = haml :_footer
    %script(type="text/javascript" src="/javascript/freebase_search.js")
    %script(type="text/javascript" src="/javascript/ga.js")
