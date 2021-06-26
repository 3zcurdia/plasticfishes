# frozen_string_literal: true

require "rack/cache"
require "sinatra"
require "json"
require_relative "fishes"

module PlasticFishes
  # App: main sinatra app
  class App < Sinatra::Base
    set :root, File.join(__dir__, "../../")

    def fishes
      @fishes ||= Fishes.new
    end

    get "/" do
      cache_control :public, max_age: 36_000
      erb :index
    end

    get "/fishes/random/?:format?" do
      if params[:format] == ".png"
        redirect to("/#{fishes.random_key}.png")
      else
        redirect to("/fishes/#{fishes.random_key}")
      end
    end

    get "/fishes/:id" do
      cache_control :public, max_age: 36_000
      @fish = params[:id]
      @fish_name = @fish.tr("-", " ").capitalize
      erb :show
    end

    get "/api/fishes/?" do
      cache_control :public, max_age: 36_000
      content_type :json
      fishes.all.to_json
    end

    get "/api/fishes/random/?" do
      content_type :json
      fishes.random.to_json
    end

    get "/api/fishes/:id/?" do
      cache_control :public, max_age: 36_000
      content_type :json
      halt(404) unless fishes.include?(params[:id])

      fishes.find(params[:id]).to_json
    end
  end
end
