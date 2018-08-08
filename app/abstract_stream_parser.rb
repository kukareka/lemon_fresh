require './app/word_counter'

class AbstractStreamParser
  WORD_REGEXP = /\w+/

  # This class is abstract.
  # The method `with_each_chunk` should be implemented in subclasses.
  #
  # Not using NotImplementedError due to http://chrisstump.online/2016/03/23/stop-abusing-notimplementederror/

  def initialize(word_counter: WordCounter.new)
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

    # Count the last word at the end of the stream
    count_word(@last_word) if @last_word.length > 0

    @total_word_count
  end

  private

  # Some magic happens here. Will be happy to know if there are better ways to parse streams with regexps in Ruby :)
  #
  # The magic: parse the stream in chunks and get the words even if they span across chunks, for instance:
  #
  #  All| pe|opl|e s|eem|to |nee|d d|ata| pr|oce|ssi|on
  #
  # "|" defines a chunk border.

  def with_each_word(chunk)
    chunk_pos = 0
    while match = WORD_REGEXP.match(chunk, chunk_pos)
      word = match[0]
      word_at_start = match.begin(0) == chunk_pos
      chunk_pos = match.end(0)
      word_at_end = chunk_pos == chunk.length

      # We try to find the next word by accumulating the parts of the word (from different chunks) in a buffer until we
      # hit the end of the word. There are 4 different cases to handle:
      case

      # Case 1: The word begins at the start of the chunk and spans till the end of the chunk. Examples:
      #
      #   |peo|ple OR p|eop|le OR |all|
      #
      # It's either a new word or continuation of a word from previous chunk. Anyway, append it to the buffer and wait
      # till the word ends.
      when word_at_start && word_at_end
        @last_word += word

      # Case 2: The word begins at the start of the chunk and ends in the middle of the chunk. Examples:
      #
      #   ne|ed | OR |to |
      #
      # It means we reached an end of some word. Yield it and clean the buffer.
      when word_at_start && !word_at_end
        yield @last_word + word
        @last_word = ''

      # Case 3: The word begins in the middle of the chunk and spans till the end of the chunk. Examples:
      #
      #   s|eem| to| OR | pe|opl|e
      #
      # It means we reached the end of the word from previous chunk (if any) and started a new word.
      # Yield the word in the buffer and start a new word.
      when !word_at_start && word_at_end
        yield @last_word if @last_word.length > 0
        @last_word = word

      # Case 4: The word begins in the middle of the chunk and ends in the middle of the chunk. Examples:
      #
      #   | a |
      #
      # It means we reached the end of the word from previous chunk (if any) and got a full new word.
      # Yield the both words and reset the buffer.
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
