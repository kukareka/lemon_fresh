require 'sinatra'
require 'stringio'

require './app/request_stream_parser'
require './app/url_stream_parser'

# Borrowed from https://stackoverflow.com/a/3028194/4731705
use Rack::Config do |env|
  if env['REQUEST_METHOD'] == 'PUT'
    env['rack.input'], env['data.input'] = StringIO.new, env['rack.input']
  end
end

# Using PUT because it modifies the state. GET endpoints should not have side effects.
put '/' do
  RequestStreamParser.new(stream: request.env['data.input']).parse!
end

put '/url' do
  UrlStreamParser.new(url: params[:url]).parse!
end

get '/' do
  WordCounter.new.count(params[:word]).to_s
end
