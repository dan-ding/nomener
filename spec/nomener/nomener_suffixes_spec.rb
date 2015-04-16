#-- encoding: UTF-8
require 'spec_helper'

RSpec.describe "Nomener::Suffixes" do
  it "has the constant regex SUFFIXES" do
    expect(Nomener::Suffixes::SUFFIXES).to be_a_kind_of(Regexp)
  end

  context "with parse_suffix" do
    [
      {from: "Mr. Joe Smith I", to: "I"},
      {from: "Joe Smith II", to: "II"},
      {from: "Joe Smith DMD", to: "DMD"},
      {from: "Joe Smith Jr. DMD", to: "Jr DMD"},
    ].each do |name|
      it "returns the suffix from #{name[:from]}" do
        parsed = Nomener::Suffixes.parse_suffix!(name[:from])
        expect(parsed).to eq name[:to]
      end
    end
  end
end