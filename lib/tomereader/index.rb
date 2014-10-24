# - розбиває контент книги на фрази та слова
# - розміщує фрази та слова в індексі
module Tomereader
  class Index
    def initialize
      @phrase_split_pattern = /[\.\;]/
      @word_pattern = /[A-Za-z]([A-Za-z\'\-])*/
      @word_storage = Hash.new
      @total_words = []
      @phrase_storage = []
    end
    def add(content)
      raise ArgumentError, "Content must be a String - #{content.class} given instead" unless content.kind_of? String
      raise StandardError, "Content is empty" if content.empty?
      phrase_strings = split_into_phrases(content)
      split(content)
      self
    end
    def split_into_phrases(content)
      content.split @phrase_split_pattern
    end
    def words
      @word_storage
    end
    def phrases
      @phrase_storage
    end
    def words_sorted_by_alphabet(count=nil)
      words = self.words.sort_by{|key, value| key}
      words = words.first(count) unless count.nil?
      Hash[words]
    end
    def words_sorted_by_frequency(count=nil)
      words = self.words.sort_by{|key, value| value.frequency}
      words = words.first(count) unless count.nil?
      Hash[words]
    end
    def to_s
      {total: @total_words.count, unique_count: @word_storage.count, phrases: @phrase_storage.count}
    end
    # розбиває текст на фрази, витягує слова,
    # встановлює звязки:  фраза -> слова, та слово -> фрази
    def split(content)
      split_into_phrases(content).map do |phrase_string|
        phrase = Phrase.new(phrase_string)
        phrase.split do |word_string, position|
          @total_words << word_string
          word = find_or_create(word_string)
          word.add(phrase, position) if word.is_a? Word
        end
        @phrase_storage << phrase
      end
  end
  # word word_storage
  def suitable? word_string
    word_string =~ @word_pattern
  end
  def find(word_string)
    if @word_storage.has_key?(word_string)
      @word_storage[word_string]
    end
  end
  def create(word_string)
    if check word_string
      @word_storage[word_string] = Word.new(word_string)
    end
  end
  def check(word_string)
    word_string.kind_of?(String) && suitable?(word_string)
  end
  def find_or_create(word_string)
    find(word_string) || create(word_string)
  end
end
end