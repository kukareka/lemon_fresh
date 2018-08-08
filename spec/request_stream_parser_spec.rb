require './app/request_stream_parser'

describe RequestStreamParser do
  describe '#parse!' do
    let(:stream) { StringIO.new(input) }
    let(:word_counter) { double('WordCounter') }
    let(:stream_parser) { described_class.new(stream: stream, word_counter: word_counter, buffer_size: buffer_size) }

    shared_examples_for 'request stream parser' do |total_word_count:|
      context 'with a small buffer' do
        let(:buffer_size) { 3 }

        it_behaves_like 'stream parser', total_word_count: total_word_count
      end

      context 'with a large buffer' do
        let(:buffer_size) { 1024 }

        it_behaves_like 'stream parser', total_word_count: total_word_count
      end
    end

    context 'a short string' do
      let(:input) { 'all people seem to need data procession' }

      it_behaves_like 'request stream parser', total_word_count: 7
    end

    context 'a string with special characters' do
      let(:input) { 'Hi! My name is (what?), my name is (who?), my name is Slim Shady' }

      it_behaves_like 'request stream parser', total_word_count: 14
    end

    context 'an empty string' do
      let(:input) { '' }

      it_behaves_like 'request stream parser', total_word_count: 0
    end

    context 'a very long string' do
      let(:input) { <<-INPUT * 100 }
        You’ve probably already used many of the applications that were built with Ruby on Rails: Basecamp, GitHub, 
        Shopify, Airbnb, Twitch, SoundCloud, Hulu, Zendesk, Square, Highrise, Cookpad. Those are just some of the big 
        names, but there are literally hundreds of thousands of applications built with the framework since its release 
        in 2004.
      INPUT

      it_behaves_like 'request stream parser', total_word_count: 5_300
    end
  end
end
