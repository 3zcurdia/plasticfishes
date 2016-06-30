require 'rubygems'
require 'sinatra'
require 'slim'
require 'json'

FISHES = Dir[File.dirname(__FILE__) + '/public/*.png'].map { |x| x.sub('/app/public','').sub('./public','').sub('.png', '').gsub('/','') }.freeze

get "/" do
  slim :index
end

get "/fish/:id" do
  @fish_name = params[:id]
  slim :fish
end

get '/random' do
  redirect to("/fish/#{FISHES.sample}")
end

get '/random.json' do
  content_type :json
  random_fish = FISHES.sample
  {
    name: random_fish,
    url: "#{request.base_url}/fish/#{random_fish}",
    image_url: "#{request.base_url}/#{random_fish}.png"
  }.to_json
end

get '/random.png' do
  redirect to("/#{FISHES.sample}.png")
end

__END__

@@ layout
doctype html
html
  head
    title Plastic Fishes
    meta name="keywords" content="plastic random fishes api"
    link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"

  body
    div.container
      == yield

@@ index
div.row.jumbotron
  div.col-md-3.col-xs-12
    img src='full-pool-eaten.png'
  div.col-md-9.col-xs-12
    h1 Plastic Fishes
    p
      a.btn.btn-primary.btn-lg href='/random' HTML
      | &nbsp;
      a.btn.btn-primary.btn-lg href='/random.json' JSON
      | &nbsp;
      a.btn.btn-primary.btn-lg href='/random.png' PNG

@@ fish
div.row
  div.col-md-3
    img src='/#{@fish_name}.png'
  div.col-md-9
    h1
      == @fish_name.gsub('-',' ').capitalize
    p Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
