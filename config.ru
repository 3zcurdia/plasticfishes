# frozen_string_literal: true

require './app'

use Rack::Cache
use Rack::Deflater
run Sinatra::Application
