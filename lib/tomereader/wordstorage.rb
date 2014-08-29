module Tomereader
   class Word
    def initialize(word)
      @name = word
      @phrases = Hash.new
    end
    def add(phrase, position)
      if @phrases.has_key? phrase
        @phrases[phrase] << position
      else
        @phrases[phrase] = [position]
      end
      self
    end
  end
  class WordStorage
    include Settings
    attr_reader :word_pattern, :logger
    attr_accessor :storage, :total_words
    def initialize
      @storage = Hash.new
      @logger = create_logger
      @total_words = []
      @word_pattern = /[A-Za-z]([A-Za-z\'\-])*/
    end
    class << self
      def word_pattern
        /^[A-Za-z]([A-Za-z\'\-])*$/
      end
      def storage
        instance.storage
      end
      def suitable? word_string
        word_string =~ instance.word_pattern
      end
      def total
        instance.total_words.count
      end
      def unique_count
        storage.count
      end
      def instance
        @@instance ||= self.new
      end
      def find(word_string)
        if check(word_string) && storage.has_key?(word_string)
          return storage[word_string]
        end
      end
      def create(word_string)
        if check word_string
          storage[word_string] = Word.new(word_string)
        end
      end
      def check(word_string)
        word_string.kind_of?(String) && suitable?(word_string)
      end
      def find_or_create(word_string)
        instance.total_words << word_string if check(word_string)
        find(word_string) || create(word_string)
      end
    end
  end
end