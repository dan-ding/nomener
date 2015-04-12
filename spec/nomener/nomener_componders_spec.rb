#-- encoding: UTF-8
require 'spec_helper'

RSpec.describe "Nomener::Compounders" do
  it "has the constant regex COMPOUNDS" do
    expect(Nomener::Compounders::COMPOUNDS).to be_a_kind_of(Regexp)
  end
end