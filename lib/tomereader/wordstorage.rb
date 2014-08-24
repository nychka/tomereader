module Tomereader
  class WordStorage
    include Settings
    def initialize
      @storage = Hash.new
      @logger = create_logger
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