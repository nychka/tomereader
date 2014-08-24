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
      expect(index.split).to eq book_info
    end
  end
  context Tomereader::WordStorage do
    let :storage do
      Tomereader::WordStorage.new
    end
    let :data do
      {word: "self-ignorable", index: 0, position: 0}
    end
    it "empty data is not suitable for storage" do
      expect(storage.suitable? "").to eq false
      expect(@log_output.readline).to match "WARN  Tomereader::WordStorage : Data type String is not suitable for storage"
    end
    it "data keys mismatch is not suitable for storage" do
      data.delete(:index)
      expect(storage.suitable? data).to eq false
      expect(@log_output.readline).to match "WARN  Tomereader::WordStorage : Data keys count mismatched"
    end
    it "is suitable for storage" do
      expect(storage.suitable? data).to eq true
    end
    it "adds word to storage" do
      storage.add data
      expect(storage.count).to eq 1
    end
  end
end