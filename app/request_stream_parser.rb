require './app/abstract_stream_parser'

class RequestStreamParser < AbstractStreamParser
  def initialize(buffer_size: (ENV['BUFFER_SIZE'] || 16_384).to_i, **args)
    super(args)

    @buffer_size = buffer_size
  end

  private

  def with_each_chunk
    stream.each(@buffer_size) { |chunk| yield chunk }
  end
end
