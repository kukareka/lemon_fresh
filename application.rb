require 'sinatra'
require 'stringio'

require './app/request_stream_parser'
require './app/url_stream_parser'
require './app/file_stream_parser'

# Borrowed from https://stackoverflow.com/a/3028194/4731705
# Reading input stream in chunks, not loading the whole request body to memory
use Rack::Config do |env|
  if env['REQUEST_METHOD'] == 'PUT'
    env['rack.input'], env['data.input'] = StringIO.new, env['rack.input']
  end
end

# Using PUT because the endpoint modifies the app state. GET endpoints should not have side effects.
put '/' do
  RequestStreamParser.new(stream: request.env['data.input']).parse!
  'OK'
end

put '/url' do
  UrlStreamParser.new(url: params[:url]).parse!
  'OK'
end

put '/file' do
  FileStreamParser.new(file_path: params[:file]).parse!
  'OK'
end

get '/' do
  WordCounter.new.count(params[:word]).to_s
end


