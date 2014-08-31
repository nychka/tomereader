module Tomereader
  class Word
    attr_reader :name#, :phrases
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
    def 
    def frequency
      phrases.count
    end
    def phrase_format(phrase)
      {source: phrase[0].to_s, positions: phrase[1]}
    end
    def phrases
      if block_given?
        @phrases.each {|phrase| yield phrase_format(phrase)}
      else
        @phrases.map{|phrase| phrase_format(phrase)}
      end
    end
    def to_s
      "#{name} : #{phrases.count}"
    end
  end
end