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
      @phrase_pattern = /[\.\;]/
    end
    def split_into_phrases
      content.split phrase_pattern
    end
    def to_s
      {words: WordStorage.total, phrases: @phrases.count}
    end
    # розбиває текст на фрази, витягує слова,
    # встановлює звязки:  фраза -> слова, та слово -> фрази
    def split
      @phrases = split_into_phrases.map do |phrase_string|
        phrase = Phrase.new(phrase_string).split
      end
      @logger.info to_s
      to_s
    end
  end
end