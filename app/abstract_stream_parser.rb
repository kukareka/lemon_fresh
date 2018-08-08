require './app/word_counter'

class AbstractStreamParser
  WORD_REGEXP = /\w+/

  def initialize(stream:, word_counter: WordCounter.new)
    @stream = stream
    @word_counter = word_counter
    @total_word_count = 0
  end

  def parse!
    @last_word = ''

    with_each_chunk do |chunk|
      with_each_word(chunk) do |word|
        count_word(word)
      end
    end

    count_word(@last_word) if @last_word.length > 0

    @total_word_count
  end

  private

  attr_reader :stream

  def with_each_word(chunk)
    chunk_pos = 0
    while match = WORD_REGEXP.match(chunk, chunk_pos)
      word = match[0]
      word_at_start = match.begin(0) == chunk_pos
      chunk_pos = match.end(0)
      word_at_end = chunk_pos == chunk.length

      case
      when word_at_start && word_at_end
        @last_word += word
      when word_at_start && !word_at_end
        yield @last_word + word
        @last_word = ''
      when !word_at_start && word_at_end
        yield @last_word if @last_word.length > 0
        @last_word = word
      when !word_at_start && !word_at_end
        yield @last_word if @last_word.length > 0
        yield word
        @last_word = ''
      end
    end
  end

  def count_word(word)
    @word_counter.add(word)
    @total_word_count += 1
  end
end
