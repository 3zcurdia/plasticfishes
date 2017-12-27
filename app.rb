# frozen_string_literal: true

require 'rubygems'
require 'rack/cache'
require 'sinatra'
require 'slim'
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
  slim :index
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
  slim :fish
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
doctype html
html
  head
    title Plastic Fishes
    meta name='keywords' content='plastic random fishes api'
    link rel='stylesheet' href='//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' integrity='sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u' crossorigin='anonymous'
  body
    div.container
      == yield
    script src='//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js' integrity='sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa' crossorigin='anonymous'

@@ index
div.row.jumbotron
  div.col-md-3.col-xs-12
    img src='full-pool-eaten.png'
  div.col-md-9.col-xs-12
    h1 Plastic Fishes
    p
      a.btn.btn-primary.btn-lg href='/fishes/random' HTML
      | &nbsp;
      a.btn.btn-primary.btn-lg href='/fishes/random.png' PNG
      | &nbsp;
      a.btn.btn-primary.btn-lg href='/api/fishes' API ALL
      | &nbsp;
      a.btn.btn-primary.btn-lg href='/api/fishes/random' API RANDOM

@@ fish
div.row
  div.col-md-3
    img src="/#{@fish}.png"
  div.col-md-9
    h1
      == @fish.gsub('-',' ').capitalize
    p Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
