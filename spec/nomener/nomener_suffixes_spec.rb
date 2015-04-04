require 'spec_helper'

RSpec.describe "Nomener::Suffixes" do
  it "has the constant regex SUFFIXES" do
    expect(Nomener::Suffixes::SUFFIXES).to be_a_kind_of(Regexp)
  end
end