require 'spec_helper'

RSpec.describe "Nomener::Name" do

  context "with initialization" do
    it "a name as a string is handled" do
      name = Nomener::Name.new("Joe Smith")
      expect(name).to be_a Nomener::Name
      expect(name.original).to eq "Joe Smith"
      expect(name.values.delete_if {|i| i.nil? || i.empty? }).to eq []
    end

    it "an empty Nomener::Name when given a non-string" do
      name = Nomener::Name.new(Random.new)
      expect(name).to be_a Nomener::Name
      expect(name.original).to eq ""
      expect(name.values.compact).to eq []
    end

    it "sets @original same string it's initialized with" do
      name = Nomener::Name.new("Joe Smith")
      expect(name).to be_a Nomener::Name
      expect(name.original).to eq "Joe Smith"
    end

    it "can not set the original after initialized with an empty string" do
      name = Nomener::Name.new("")
      expect {
        name.original = "Joe Smith"
      }.to raise_error NoMethodError
      expect(name).to be_a Nomener::Name
    end
  end

  context "with parse" do
    it "it parses 'Joe Smith'" do
      name = Nomener::Name.new("Joe Smith")
      name.parse
      expect(name.first).to eq "Joe"
      expect(name.last).to eq "Smith"
    end
  end

  context "with properlike" do
    it "returns the name in a nice case" do
      name = Nomener::Name.new("joE SmItH")
      name.parse
      expect(name.properlike).to eq "Joe Smith"
    end
  end

  context "with to_s" do
    it "returns the name in a original case" do
      name = Nomener::Name.new("joE SmItH")
      name.parse
      expect(name.to_s).to eq "joE SmItH"
    end

    it "can be used in a string" do
      name = Nomener::Name.new("Joe Smith")
      name.parse
      expect("Hello #{name}!").to eq "Hello Joe Smith!"
    end
  end

  context "with name" do
    it "follows the format and returns 'Bob Bob Bob' from 'Bob Smith'" do
      name = Nomener::Name.new("Bob Smith")
      name.parse
      expect(name.name("%f %f %f")).to eq "Bob Bob Bob"
    end
  end

  context "with full" do
    it "returns the entire parsed name as a string" do
      name = Nomener::Name.new("Mr. Joe Bob Smith")
      name.parse
      expect(name.full).to eq "Joe Bob Smith"
    end
  end

  context "with inspect" do
    it "details the object with only the parsed strings" do
      name = Nomener::Name.new("Mr. Joe Smith")
      name.parse
      expect(name.inspect).to eq '#<Nomener::Name title="Mr" first="Joe" last="Smith">'
    end
  end

  context "with capit" do
    name = Nomener::Name.new
    [
      {from: "smith", to: "Smith"},
      {from: "mckracken", to: "McKracken"},
      {from: "macgrady", to: "MacGrady"},
      {from: "macmurdo", to: "MacMurdo"},
      {from: "machin", to: "Machin"},
      {from: "o'reilly", to: "O'Reilly"},
      {from: "d'angelo", to: "D'Angelo"},
      {from: "allison-tiani", to: "Allison-Tiani"},
      {from: "o miller", to: "O Miller"},
      {from: "van 't hooft", to: "Van 't Hooft"},
      {from: "van 't hooft-page", to: "Van 't Hooft-Page"}
    ].each do |cap|
      it "make nice '#{cap[:to]}' from '#{cap[:from]}'" do
        expect(name.capit(cap[:from])).to eq cap[:to]
      end
    end
  end


end