require 'rubygems'
require 'sinatra'
require 'slim'

FISHES = Dir[File.dirname(__FILE__) + '/public/*.png'].freeze
fish =


get "/fish" do
  slim :fish
end

get "/random_fish" do
  "#{request.host}#{FISHES.sample.sub('./public','')}}"
end


__END__

@@ layout
doctype html
html
  head
    title PlasticFishes
    meta name="keywords" content="twitter feed analizer"

  body
    #content
      == yield

@@ fish
h1 Lorem ipsum dolor quet
