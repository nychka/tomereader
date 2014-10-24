module Tomereader
  class Parser
    attr_reader :format_pattern, :filename, :reader
    def initialize(filename)
      raise ArgumentError, "Specify correct filename" if not filename and filename.empty?
      raise StandardError, "File #{filename} not exists" unless File.exists? filename
      @filename = filename
      @format_pattern = /[a-z0-9_\-\.]+\.([a-z0-9]{3,4})$/
    end
    def format
      @match = format_pattern.match(filename)
      format = @match[1]
      raise StandardError, "Format is undefined" unless @match && format
      format
    end
    def read
      case format
      when 'pdf'
        #TODO: check if pdftotext installed
        raise StandardError, "pfdtotext not installed" unless system('pdftotext -v')
        open("|pdftotext #{filename} -").read() 
      when 'txt'
        File.read(filename)
      else
        raise StandardError, "ebook-convert is not installed. Try: sudo apt-get install calibre" unless system('ebook-convert --version')
        temp_file = Tempfile.new([@match[0], '.txt'])
        system("ebook-convert #{filename} #{temp_file.path}")
        content = temp_file.read
        temp_file.close
        temp_file.unlink
        content
      end
    end
    def pages_count
      reader.page_count
    end
  end
end