module Tomereader
  class Phrase
    include Settings
    attr_reader :words
    def initialize(phrase_string)
      @phrase_string = phrase_string.strip
      @word_pattern = /[\s,;\"]+/
      @words = []
      @logger = create_logger
    end
    def to_s
      @phrase_string
    end
    def word_strings
      @phrase_string.split @word_pattern
    end
    # split phrase into words
    # @return Array of words
    def split
      return false if words.count > 0
      begin
        word_strings.each_with_index do |word_string, position|
          word = WordStorage.find_or_create(word_string)
          #raise TypeError, "must be Word type - #{word.class} given instead" unless word.is_a? Word
          @words << word.add(self, position) if word.is_a? Word
        end
        words.count
      rescue => e
        @logger.warn e.message
      end
    end
  end
end