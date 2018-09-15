# frozen_string_literal: true

require 'rubygems'
require 'rack/cache'
require 'sinatra'
require 'json'

# Assets logic to read assets filanmes and filepaths
module Assets
  module_function

  def filenames
    file_paths.map { |x| sanitize_filepath(x) }
  end

  def file_paths
    Dir[File.dirname(__FILE__) + '/public/*.png']
  end

  def sanitize_filepath(path)
    path.split('/').last.sub('.png', '')
  end
end

# PlasticFishesApp: main app
class PlasticFishesApp < Sinatra::Base
  FISHES = Assets.filenames.freeze

  def hash_for_fish(id)
    {
      id: id,
      name: id.tr('-', ' ').capitalize,
      text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      api_url: "#{request.base_url}/api/fishes/#{id}",
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
    @fish_name = @fish.tr('-', ' ').capitalize
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
end
