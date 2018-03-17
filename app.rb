# frozen_string_literal: true

require 'rubygems'
require 'rack/cache'
require 'sinatra'
require 'json'

FISHES = Dir[File.dirname(__FILE__) + '/public/*.png'].map { |x| x.sub('/app/public', '').sub('./public', '').sub('.png', '').delete('/') }.freeze

def hash_for_fish(id)
  {
    id: id,
    name: id.tr('-', ' ').capitalize,
    text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    api_url: "#{request.base_url}/api/fishes/#{id}.json",
    web_url: "#{request.base_url}/fishes/#{id}",
    image_url: "#{request.base_url}/#{id}.png"
  }
end

get '/' do
  cache_control :public, max_age: 36_000
  erb :index
end

get '/fishes/random' do
  redirect to("/fishes/#{FISHES.sample}")
end

get '/fishes/random.png' do
  redirect to("/#{FISHES.sample}.png")
end

get '/fishes/:id' do
  cache_control :public, max_age: 36_000
  @fish = params[:id]
  @fish_name = @fish.gsub('-',' ').capitalize
  erb :show
end

get '/api/fishes' do
  cache_control :public, max_age: 36_000
  content_type :json
  FISHES.map { |name| hash_for_fish(name) }.to_json
end

get '/api/fishes/random' do
  content_type :json
  hash_for_fish(FISHES.sample).to_json
end

get '/api/fishes/:id' do
  cache_control :public, max_age: 36_000
  content_type :json
  return {}.to_json unless FISHES.include?(params[:id])
  hash_for_fish(params[:id]).to_json
end


__END__

@@ layout
<html>
  <head>
    <title>Plastic Fishes</title>
    <meta name="keywords" content="plastic random fishes api" />
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic" />
    <link rel="stylesheet" href="//cdn.rawgit.com/necolas/normalize.css/master/normalize.css" />
    <link rel="stylesheet" href="//cdn.rawgit.com/milligram/milligram/master/dist/milligram.min.css" />
  </head>
  <body>
    <div class="container"><%= yield %></div>
  </body>
 </html>

@@ index
<div class="row">
  <div class="column column-20">
    <img src="full-pool-eaten.png"/>
  </div>
  <div class="column column-80">
    <h1>Plastic Fishes</h1>
    <p>
      <a class="button button-outline" href="/fishes/random">HTML</a>
      &nbsp;
      <a class="button button-outline" href="/fishes/random.png">PNG</a>
      &nbsp;
      <a class="button button-outline" href="/api/fishes">API ALL</a>
      &nbsp;
      <a class="button button-outline" href="/api/fishes/random">API RANDOM</a>
    </p>
  </div>
</div>

@@ show
<div class="row">
  <div class="column column-20">
    <img src='<%= "/#{@fish}.png" %>'/>
  </div>
  <div class="column column-80">
    <h1><%= @fish_name %></h1>
    <p>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit,
      sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
      nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
      reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
      pariatur. Excepteur sint occaecat cupidatat non proident,
      sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
  </div>
</div>
