require './app/abstract_stream_parser'

class FileStreamParser < AbstractStreamParser
  BASE_DIRECTORY = File.expand_path('public')

  def initialize(file_path:, **args)
    super(args)

    @file_path = File.expand_path(file_path, BASE_DIRECTORY)

    # Protect from '../../something' paths that could reference files beyond the `public` directory
    raise IOError.new('Access violation') unless @file_path.start_with?(BASE_DIRECTORY)
  end

  private

  def with_each_chunk
    # Reading the file in chunks, not loading the whole file into memory
    IO.foreach(@file_path, encoding: 'utf-8') { |chunk| yield chunk }
  end
end
