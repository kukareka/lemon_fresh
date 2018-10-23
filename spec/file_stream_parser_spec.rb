require './app/file_stream_parser'

describe FileStreamParser do
  describe '.new' do
    subject { -> { described_class.new(file_path: file_path) } }

    context 'valid file path' do
      let(:file_path) { 'some_file.txt' }

      it { is_expected.not_to raise_error }
    end

    context 'invalid file path' do
      let(:file_path) { '../some_file.txt' }

      it { is_expected.to raise_error(IOError) }
    end
  end

  describe '#parse!' do
    let(:word_counter) { double('WordCounter') }
    let(:stream_parser) do
      described_class.new(file_path: file_path, word_counter: word_counter)
    end

    context 'valid file path' do
      let(:input) { File.read(File.expand_path(file_path, described_class::BASE_DIRECTORY), encoding: 'utf-8') }
      let(:file_path) { 'agile_manifesto.txt' }

      it_behaves_like 'stream parser', total_word_count: 130
    end

    context 'invalid file path' do
      let(:file_path) { 'no_such_file.txt' }

      specify do
        expect { stream_parser.parse! }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
