require 'webmock/rspec'

require './app/url_stream_parser'

describe UrlStreamParser do
  describe '#parse!' do
    let(:url) { 'http://www.example.com' }
    let(:input) { 'some http response' }
    let(:word_counter) { double('WordCounter') }
    let(:stream_parser) do
      described_class.new(url: url, word_counter: word_counter)
    end

    before do
      stub_request(:get, url).to_return(body: input)
    end

    it_behaves_like 'stream parser', total_word_count: 3
  end
end
