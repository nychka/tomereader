# - розбиває контент книги на фрази та слова
# - розміщує фрази та слова в індексі
module Tomereader
  class Index
    attr_reader :content, :word_pattern, :phrase_pattern
    include Settings
    def initialize(content)
      raise ArgumentError, "Content must be a String - #{content.class} given instead" unless content.kind_of? String
      raise StandardError, "Content is empty" if content.empty?
      @logger = create_logger
      @content = content
      #TODO: catch artefacts like:  [“ ™ ﬁnd]
      @word_pattern = /[\s,;\"]+/
      @phrase_pattern = /[\.\;]/
      @word_storage = WordStorage.new
    end
    def split_into_phrases
      content.split phrase_pattern
    end
    def to_s
      {words: @word_storage.count, phrases: @phrases.count}
    end
    def split
      @phrases = split_into_phrases
      @phrases.each_with_index do |phrase, index|
        words = phrase.strip.split word_pattern
        words.each_with_index do |word, position|
          @word_storage.add({word: word, index: index,position: position})
        end
      end
      @logger.info to_s
      to_s
    end
  end
end