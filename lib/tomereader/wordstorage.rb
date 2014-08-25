module Tomereader
  class Phrase < Hash
    def initialize(phrase_string)
      @phrase_string = phrase_string.strip
      @word_pattern = /[\s,;\"]+/
      @words = []
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
      return false if @words.count > 0 
      word_strings.each_with_index do |word_string, position|
        # create word only it does not exist !!!
        #if word exists in word_storage, add phrase to word's phrases
        word = WordStorage.find_or_create(word_string)
        if word
          word.add(self, position) # find by key
          @words << word #
        end 
        # Добавляємо фразу у слово, та позицію слова у фразі
        #@word_storage.add({word: word, index: index,position: position})
      end
    end
  end
  # words = {
  #   'hello' => {0 => [5], 4 => [1], name: 'hello'},
  #   'cat' => {67 => [6,7], 128 => [12, 8], name: ''}
  #}
  class Word < Hash
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
    end
  end
  # зберігає слова, знаходить потрібне слово
  # TODO: make it singleton
  class WordStorage
    include Settings
    def initialize
      @storage = Hash.new
      @logger = create_logger
    end
    def storage
      @storage
    end
    def self.total
      self.instance.count
    end
    def self.instance
      @@instance ||= self.new
    end
    def self.find_or_create(word_string)
      storage = self.instance.storage
      if storage.has_key? word_string
        storage[word_string] # <= Word
      else
        if word_string =~ self.instance.format[:word]
          storage[word_string] = Word.new(word_string)
        else
          false
        end
      end
    end
    def format
      {word: /^[A-Za-z]([A-Za-z\'\-])*$/, index: /^[\d]+$/, position: /^[\d]+$/}
    end
    def add(data)
      push(data[:word], data) if suitable? data
    end
    def count
      @storage.count
    end
    def push(key, data)
      if @storage.has_key? key
        @storage[key].push data
      else
        @storage[key] = [data]
      end
    end
    def suitable? data
      response = check(data)
      @logger.warn response if response.kind_of? String
      not response.kind_of? String
    end
    def check(data)
      return "Data type #{data.class} is not suitable for storage" unless data.kind_of? Hash
      return "Data keys count mismatched" unless data.count == format.count
      format.each_pair do |key, pattern|
        if data.has_key? key
          return "#{key} format mismatched: #{data[key]}" unless data[key].to_s =~ pattern
        else
          return "Data doesn't have key #{key}"
        end
      end
      true
    end
  end
end