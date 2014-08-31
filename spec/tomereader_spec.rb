require 'spec_helper'

describe Tomereader do
  before do
    path = File.expand_path(File.dirname(__FILE__) + "/../data")
    filename = "three_phrases.txt"
    @file = File.join(path, filename)
  end
  let(:parser) { Tomereader::Parser.new(@file) }
  context Tomereader::Parser do
    it "has correct filename path" do
      expect(File.exists? @file).to eq true
    end
    it "has content" do
      expect(parser.read.length).to be > 0
    end
  end
  context Tomereader::Index do
    let(:content) { parser.read }
    let(:word) { "tomereader" }
    let(:index) { Tomereader::Index.new(content) }
    let(:book_info) { {:total=>64, :phrases=>5} }
    
    it "split_into_phrases" do
      expect(index.split_into_phrases.count).to eq book_info[:phrases]
    end
    it "#split" do
      index.split
      expect(index.to_s[:total]).to eq book_info[:total]
    end
    it "shows list of words and their frequency" do
      content = index.show_words
      expect(content.count).to be > 0
    end
    it "empty word is not suitable for storage" do
      expect(index.suitable? "").to_not eq true
    end
    it "creates word in word storage" do
      expect(index.create(word)).to be_a Tomereader::Word
    end
    it "finds word in word storage" do
      index.create(word)
      expect(index.find(word)).to be_a Tomereader::Word
    end
  end
end