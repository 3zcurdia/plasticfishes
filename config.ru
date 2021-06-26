# frozen_string_literal: true

require 'bundler/setup'
require_relative 'lib/plastic_fishes'

use Rack::Cache
use Rack::Deflater
run PlasticFishes::App
