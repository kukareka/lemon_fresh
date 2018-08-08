require 'sinatra'
require 'stringio'

require './app/stream_parser'

# Borrowed from https://stackoverflow.com/a/3028194/4731705
use Rack::Config do |env|
  if env['REQUEST_METHOD'] == 'PUT'
    env['rack.input'], env['data.input'] = StringIO.new, env['rack.input']
  end
end

put '/' do
  StreamParser.new(request.env['data.input']).parse!
end

get '/' do
  'Thank you.'
end
