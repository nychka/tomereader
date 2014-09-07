require 'spec_helper'

describe Tomereader do
  before do
    @path = File.expand_path(File.dirname(__FILE__) + "/../data")
    filename = "three_phrases.txt"
    @file = File.join(@path, filename)
  end

  let(:parser) { Tomereader::Parser.new(@file) }
  context Tomereader::Parser do
    it "has correct filename path" do
      expect(File.exists? @file).to eq true
    end
    it "has content" do
      expect(parser.read.length).to be > 0
    end
    it "converts pdf to txt and reads" do
      filename = "evented-spec.pdf"
      file = File.join(@path, filename)
      expect(File.exists?(file)).to eq true
      parser = Tomereader::Parser.new(file)
      expect(parser.read.length).to be > 0
    end
    it "creates temp file" do
      temp_file = Tempfile.new(["test", '.txt'])
      expect(File.exists?(temp_file)).to eq true
      temp_file.close
      temp_file.unlink
    end
    it "converts fb2 to txt and reads" do
      filename = "stormrage.fb2"
      file = File.join(@path, filename)
      expect(File.exists?(file)).to eq true
      parser = Tomereader::Parser.new(file)
      expect(parser.read.length).to be > 0
    end
  end
  context Tomereader::Index do
    let(:content) { parser.read }
    let(:word) { "tomereader" }
    let(:index) { Tomereader::Index.new}
    let(:book_info) { {:total=>64, :phrases=>5} }
    
    before(:each){index.add(content)}

    it "creates word in word storage" do
      expect(index.create(word)).to be_a Tomereader::Word
    end
    it "finds word in word storage" do
      index.create(word)
      expect(index.find(word)).to be_a Tomereader::Word
    end
    it "empty word is not suitable for storage" do
      expect(index.suitable? "").to_not eq true
    end
    it "split_into_phrases" do
      expect(index.split_into_phrases(content).count).to eq book_info[:phrases]
    end
    it "#split" do
      expect(index.to_s[:total]).to eq book_info[:total]
    end
    it "shows word's list of phrases" do
      word = index.find('alike')
      phrases = word.phrases
      expect(phrases.count).to eq 1
      expect(phrases[0][:source]).to eq "We don’t look alike"
      expect(phrases[0][:positions]).to be_a_kind_of Array
      expect(phrases[0][:positions][0]).to eq 3
    end
    it "shows word's list sorted by frequency" do
      hash = index.words_sorted_by_frequency
      expect(hash.first[0]).to eq "I"
    end
  end
end