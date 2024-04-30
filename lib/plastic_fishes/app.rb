# frozen_string_literal: true

require "rack/cache"
require "roda"
require "rapidjson"
require_relative "fishes"

module PlasticFishes
  # App: main roda app
  class App < Roda
    plugin :render
    plugin :caching
    plugin :public
    plugin :json, serializer: proc { RapidJSON.encode(_1) }

    def fishes
      @fishes ||= Fishes.new
    end

    route do |r|
      r.public
      r.root { view(:index) }

      r.on "fishes" do
        r.is "random" do
          r.get { r.redirect "/fishes/#{fishes.random_key}" }
        end

        r.on String do |id|
          @fish = fishes.find(id)
          r.get do
            response.cache_control(public: true, max_age: 36_000)
            if @fish
              view(:show)
            else
              response.status = 404
              { error: "Fish not found" }
            end
          end
        end
      end

      r.on "api" do
        r.on "fishes" do
          r.is "random" do
            r.get { fishes.random }
          end

          r.is String do |id|
            @fish = fishes.find(id)
            r.get do
              response.cache_control(public: true, max_age: 36_000)
              if @fish
                @fish
              else
                response.status = 404
                { error: "Fish not found" }
              end
            end
          end

          r.is do
            r.get do
              response.cache_control(public: true, max_age: 36_000)
              fishes.all
            end
          end
        end
      end
    end
  end
end
