require 'rubygems'
require 'sinatra'
require 'slim'
require 'json'

FISHES = Dir[File.dirname(__FILE__) + '/public/*.png'].map { |x| x.sub('/app/public','').sub('./public','').sub('.png', '').gsub('/','') }.freeze

get "/" do
  slim :index
end

get "/fish/:id" do
  slim :fish
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
    title PlasticFishes
    link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/pure/0.6.0/pure-min.css"
    meta name="keywords" content="twitter feed analizer"

  body
    div.pure-g
      div.pure-u-2-24
      div.pure-u-20-24
        == yield
      div.pure-u-2-24

@@ index
  div.pure-g
    div.pure-u-6-24
      img src='full-pool-eaten.png'
    div.pure-u-18-24
      h1 Hello random fishes
      p
        a class='pure-button pure-button-primary button-xlarge' href='/random.json' JSON
        | &nbsp;
        a class='pure-button pure-button-primary button-xlarge' href='/random.png' PNG

@@ fish
h1 Lorem ipsum dolor quet
