require "tomereader/version"
require "pdf/reader"

module Tomereader
  class PDFReader
    def initialize(filename)
      @reader = PDF::Reader.new(filename)
    end
    def pages_count
      @reader.page_count
    end
    def read
      @reader.pages.map(&:text)
    end
  end
end
