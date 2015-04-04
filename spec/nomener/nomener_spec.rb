require 'spec_helper'

RSpec.describe "Nomener" do
  it "has the class method parse" do
    expect(Nomener.singleton_methods).to match_array [:parse]
  end

  context "with the method parse" do
    it "throw ArgumentError when passed no arguments" do
      expect { Nomener.parse() }.to raise_error ArgumentError
    end

    it "returns an empty Nomener::Name when given a non-string" do
      parser = Nomener.parse(Random.new)
      expect(parser.values.compact).to eq []
      expect(parser).to be_a Nomener::Name
    end

    it "returns a Nomener::Name when given a string" do
      parser = Nomener.parse("Joe Smith")
      expect(parser.values.delete_if {|i| i.empty? }).to eq ["Joe", "Smith"]
      expect(parser).to be_a Nomener::Name
    end

    it "parses 'Joe Smith'" do
      parser = Nomener.parse("Joe Smith")
      expect(parser.first).to eq "Joe"
      expect(parser.last).to eq "Smith"
    end
  end
end