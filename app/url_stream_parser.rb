require './app/abstract_stream_parser'

class UrlStreamParser < AbstractStreamParser
  def initialize(url:, **args)
    super(args)

    @url = url
  end

  private

  def with_each_chunk
    uri = URI(@url)

    Net::HTTP.start(uri.host, uri.port,
                    use_ssl: uri.scheme == 'https',
                    verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      request = Net::HTTP::Get.new uri

      http.request request do |response|
        response.read_body { |chunk| yield chunk }
      end
    end
  end
end
