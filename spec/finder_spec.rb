require "finder"

describe Finder do
  let(:finder) { Finder.new(File.read('SystemViewController.json'))}

  context "given a simple query" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('Input').length).to eq(26)
    end
  end

  context "given an identifier" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('#verticalSync').length).to eq(1)
    end
  end

  context "given a property" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('[max=2]').length).to eq(7)
    end
  end

  context "given a class" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('.column').length).to eq(3)
    end
  end

  context "given a compound query" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('CvarSlider[max=2]').length).to eq(7)
    end
  end

  context "given a chained query" do
    it "finds the expected number of nodes" do
      expect(finder.find_nodes('Box CvarSlider[max=1]').length).to eq(4)
    end
  end

  context "given an invalid query" do
    it "raises an error" do
      expect {finder.find_nodes('!invalid')}.to raise_error(RuntimeError)
    end
  end


end
