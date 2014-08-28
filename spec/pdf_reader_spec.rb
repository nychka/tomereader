require 'spec_helper'

describe Tomereader do
  before do
    path = File.expand_path(File.dirname(__FILE__) + "/../data")
    filename = "content.pdf"
    @file = File.join(path, filename)
  end
  let :parser do
     Tomereader::Parser.new(@file)
  end
  context Tomereader::Parser do
    it "has correct filename path" do
      expect(File.exists? @file).to eq true
    end
    it "#format is .pdf" do
      expect(parser.format).to eq "pdf"
    end
    it "#page_count is 2" do
      expect(parser.pages_count).to eq 2
    end
    it "#read" do
      expect(parser.read.length).to be > 0
    end
  end
  context Tomereader::Index do
    let :content do
      parser.read
    end
    let :index do
      Tomereader::Index.new(content)
    end
    let :book_info do
      {:words=>295, :phrases=>27}
    end
    it "split_into_phrases" do
      expect(index.split_into_phrases.count).to eq book_info[:phrases]
    end
    it "#split" do
      expect(index.split).to eq book_info[:words]
    end
  end
  context Tomereader::WordStorage do
    let :storage do
      Tomereader::WordStorage
    end
    let :word do
      "tomereader"
    end
    it "empty word is not suitable for storage" do
      expect(storage.suitable? "").to_not eq true
    end
    it "creates word in storage" do
      expect(storage.create(word)).to be_a Tomereader::Word
    end
    it "finds word in storage" do
      storage.create(word)
      expect(storage.find(word)).to be_a Tomereader::Word
    end
  end
end