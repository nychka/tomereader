module Tomereader
  class Parser
    attr_reader :format_pattern, :filename, :reader
    def initialize(filename)
      raise ArgumentError, "Specify correct filename" if not filename and filename.empty?
      @filename = filename
      @format_pattern = /\.([a-z]{3,4})$/
    end
    def format
      match = format_pattern.match(filename)
      format = match[1]
      raise StandardError, "Format is undefined" unless match && format
      format
    end
    def read
      case format
      when 'pdf'
        reader = PDF::Reader.new(filename)
        content = reader.pages.map(&:text)
        raise StandardError, "Content is empty" if content.empty?
        content.join.gsub(/[\s\n]+/, " ")
      when 'txt'
        File.read(filename)
      else
        raise StandardError, "Unfortunatelly, format #{format} is unsupported"
      end
    end
    def pages_count
      reader.page_count
    end
  end
end