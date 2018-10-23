shared_examples_for 'stream parser' do |total_word_count:|
  before do
    input.split(/\W+/).group_by(&:itself).each do |word, occurrences|
      expect(word_counter).to receive(:add).with(word).exactly(occurrences.count).times if word.length > 0
    end
  end

  subject { stream_parser.parse! }

  it { is_expected.to eq(total_word_count) }
end
