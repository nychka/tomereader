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
  # зберігає слова, знаходить потрібне слово
  # TODO: make it singleton
  class WordStorage
    include Settings
    attr_reader :word_pattern, :logger
    attr_accessor :storage, :artefacts
    def initialize
      @storage = Hash.new
      @logger = create_logger
      @artefacts = []
      @word_pattern = /^[A-Za-z]([A-Za-z\'\-])*$/
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
      def add_artefact(word_string)
        instance.artefacts << word_string
        false
        #raise TypeError, "#{word_string} word is not suitable"
      end
      def check(word_string)
        unless word_string.kind_of? String
          raise TypeError,"Only String supported - #{word_string.class} given instead for" 
        end
        unless suitable? word_string
          add_artefact(word_string) 
        else
          true
        end
      end
      def find_or_create(word_string)
        find(word_string) || create(word_string)
      end
    end
  end
end