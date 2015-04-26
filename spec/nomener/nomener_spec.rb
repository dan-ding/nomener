#-- encoding: UTF-8
require 'spec_helper'

RSpec.describe "Nomener" do
  it "has the class method parse" do
    expect(Nomener.singleton_methods).to include :parse
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

  context "with configure" do
    after(:each) do
      Nomener.reset
    end

    it "can be configured" do
      config = Nomener.configure
      expect(config).to be_a Nomener::Configuration
    end

    it "can be reset" do
      config = Nomener.reset
      expect(config.left).to eq '"'
      expect(config.right).to eq '"'
      expect(config.single).to eq '\''
      expect(config.lang).to eq :en
    end

    it "can configure the left quote" do
      Nomener.config.left = ':'
      expect(Nomener.config.left).to eq ':'
    end

    it "can configure the right quote" do
      Nomener.config.right = ':'
      expect(Nomener.config.right).to eq ':'
    end

    it "can configure the single quote" do
      Nomener.config.single = ':'
      expect(Nomener.config.single).to eq ':'
    end

    it "can configure the language" do
      Nomener.config.lang = :fr
      expect(Nomener.config.lang).to eq :fr
    end

    it "can configure the direction" do
      Nomener.config.dir = :rtl
      expect(Nomener.config.dir).to eq :rtl
    end

    it "can configure the name format" do
      Nomener.config.format = '%f %l'
      expect(Nomener.config.format).to eq '%f %l'
    end

    it "can be configured with a block" do
      Nomener.configure do |con|
        con.left = '-'
        con.right = '*'
        con.single = '^'
        con.format = '%f'
        con.dir = :rtl
        con.lang = :de
      end
      expect(Nomener.config.left).to eq '-'
      expect(Nomener.config.right).to eq '*'
      expect(Nomener.config.single).to eq '^'
      expect(Nomener.config.format).to eq '%f'
      expect(Nomener.config.dir).to eq :rtl
      expect(Nomener.config.lang).to eq :de
    end
  end
end