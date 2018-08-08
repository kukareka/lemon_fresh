require './app/abstract_stream_parser'

class RequestStreamParser < AbstractStreamParser
  def initialize(stream:, buffer_size: (ENV['BUFFER_SIZE'] || 16_384).to_i, **args)
    # Passing all except my own arguments to the base class
    super(args)

    @stream = stream
    @buffer_size = buffer_size
  end

  private

  def with_each_chunk
    @stream.each(@buffer_size) { |chunk| yield chunk }
  end
end
