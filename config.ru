require './app'

use Rack::Cache
use Rack::Deflater
run Sinatra::Application
