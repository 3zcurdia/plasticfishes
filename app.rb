# frozen_string_literal: true

require 'rubygems'
require 'rack/cache'
require 'sinatra'
require 'singleton'
require 'json'

# Assets logic to read assets filanmes and filepaths
module Assets
  module_function

  def filenames
    file_paths.map { |x| sanitize_filepath(x) }
  end

  def file_paths
    Dir["#{File.dirname(__FILE__)}/public/*.png"]
  end

  def sanitize_filepath(path)
    path.split('/').last.sub('.png', '')
  end
end

# Store generasete a s simulated database store
class Store
  include Singleton

  def initialize
    @fishes = Assets.filenames.map do |filename|
      [filename, build(filename)]
    end.to_h.freeze
  end

  def all
    fishes.values
  end

  def find(id)
    fishes[id]
  end

  def include?(id)
    fishes.key?(id)
  end

  def random_key
    fishes.keys.sample
  end

  def random
    find(random_key)
  end

  private

  attr_reader :fishes

  def build(key)
    {
      id: key,
      name: key.tr('-', ' ').capitalize,
      uuid: SecureRandom.uuid,
      number: SecureRandom.hex(3).to_i(16),
      bigint: SecureRandom.hex(32).to_i(16),
      text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      api_path: "/api/fishes/#{key}",
      web_path: "/fishes/#{key}",
      image_path: "/#{key}.png",
      created_at: Time.now.utc.iso8601
    }
  end
end

# PlasticFishesApp: main app
class PlasticFishesApp < Sinatra::Base
  get '/' do
    cache_control :public, max_age: 36_000
    erb :index
  end

  get '/fishes/random/?:format?' do
    if params[:format] == '.png'
      redirect to("/#{Store.instance.random_key}.png")
    else
      redirect to("/fishes/#{Store.instance.random_key}")
    end
  end

  get '/fishes/:id' do
    cache_control :public, max_age: 36_000
    @fish = params[:id]
    @fish_name = @fish.tr('-', ' ').capitalize
    erb :show
  end

  get '/api/fishes/?' do
    cache_control :public, max_age: 36_000
    content_type :json
    Store.instance.all.to_json
  end

  get '/api/fishes/random/?' do
    content_type :json
    Store.instance.random.to_json
  end

  get '/api/fishes/:id/?' do
    cache_control :public, max_age: 36_000
    content_type :json
    halt(404) unless Store.instance.include?(params[:id])

    Store.instance.find(params[:id]).to_json
  end
end
