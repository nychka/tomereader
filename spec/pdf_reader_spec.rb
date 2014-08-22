require 'spec_helper'

describe Tomereader::PDFReader do
  before do
    path = File.expand_path(File.dirname(__FILE__) + "/../data")
    filename = "content.pdf"
    @file = File.join(path, filename)
  end
  let :reader do
     Tomereader::PDFReader.new(@file)
  end
  it "checks if file exist" do
    expect(File.exists? @file).to eq true
  end
  it "has two pages" do
    expect(reader.pages_count).to eq 2
  end
  it "has text" do
    expect(reader.read.count).to be > 0
  end
end