require 'spec_helper'

RSpec.describe "Nomener::Parser" do

  context "with parse" do
    it "nil is returned when given a non-string" do
      name = Nomener::Parser.parse(Random.new)
      expect(name).to be_nil
    end

    it "nil is returned when given no arguments" do
      expect {
        Nomener::Parser.parse()
      }.to raise_error ArgumentError
    end

    it "can not set the original after initialized with an empty string" do
      name = Nomener::Name.new("")
      expect {
        name.original = "Joe Smith"
      }.to raise_error NoMethodError
      expect(name).to be_a Nomener::Name
    end

    it "throw ParseError when passed too many commas" do
      expect {
        Nomener::Parser.parse!("Joe, John, Smith")
      }.to raise_error Nomener::ParseError
    end

    [
      {from: "Joe Smith", to: { first: "Joe", last: "Smith"} },
      {from: "Joe Smith Jr.", to: { first: "Joe", last: "Smith", suffix: "Jr"} },
      {from: "Joe Van 't Hooft", to: { first: "Joe", last: "Van 't Hooft"} },
      {from: "Mr. Joe Smith", to: { title: "Mr", first: "Joe", last: "Smith"} },
      {from: "Mr. Joe Smith Jr.", to: { title: "Mr", first: "Joe", last: "Smith", suffix:"Jr"} },
      {from: "Mr. Joe Smith III", to: { title: "Mr", first: "Joe", last: "Smith", suffix:"III"} },
      {from: "Mr. Joe \"Spud\" Smith III", to: { title: "Mr", first: "Joe", last: "Smith", suffix: "III", nick: "Spud"} },
    ].each do |name|
      it "returns a hash of the parsed name #{name[:from]}" do
        parsed = Nomener::Parser.parse!(name[:from])
        name[:to].keys.each do |key|
          expect(parsed[key]).to eq name[:to][key]
        end
      end
    end

  end

  context "with parse_title" do
    [
      {from: "Mr. Joe Smith", to: "Mr"},
      {from: "Joe Smith", to: ""},
    ].each do |name|
      it "returns the title from #{name[:from]}" do
        parsed = Nomener::Parser.parse_title!(name[:from])
        expect(parsed).to eq name[:to]
      end
    end
  end

  context "with parse_suffix" do
    [
      {from: "Mr. Joe Smith I", to: "I"},
      {from: "Joe Smith II", to: "II"},
      {from: "Joe Smith DMD", to: "DMD"},
      {from: "Joe Smith Jr. DMD", to: "Jr DMD"},
    ].each do |name|
      it "returns the suffix from #{name[:from]}" do
        parsed = Nomener::Parser.parse_suffix!(name[:from])
        expect(parsed).to eq name[:to]
      end
    end
  end

  context "with parse_nick" do
    [
      {from: "Joe Smith", to: ""},
      {from: "Joe (Spud) Smith II", to: "Spud"},
      {from: "Joe \"Spud\" Smith DMD", to: "Spud"},
    ].each do |name|
      it "returns the suffix from #{name[:from]}" do
        parsed = Nomener::Parser.parse_nick!(name[:from])
        expect(parsed).to eq name[:to]
      end
    end
  end

  context "with parse_last" do
    [
      {from: "Joe Smith", to: "Smith", opts: :fl},
      {from: "Smith Joe", to: "Smith", opts: :lf},
      {from: "Smith, Joe", to: "Smith", opts: :lcf},
      {from: "Smith, Joe Jr.", to: "Smith", opts: :lcf},
    ].each do |name|
      it "returns the suffix from #{name[:from]}" do
        parsed = Nomener::Parser.parse_last!(name[:from], name[:opts])
        expect(parsed).to eq name[:to]
      end
    end
  end

  context "with parse_first" do
    [
      { from: "Mary", to: ["Mary", ""], opts: 0 },
      { from: "Mary Sue", to: ["Mary", "Sue"], opts: 0 },
      { from: "Mary Sue", to: ["Mary Sue", ""], opts: 1 },
    ].each do |name|
      it "returns the first name #{name[:to][0]} from #{name[:from]}" do
        parsed = Nomener::Parser.parse_first!(name[:from], name[:opts])
        expect(parsed).to eq name[:to]
      end
    end
  end

end