require 'spec_helper'

RSpec.describe "Nomener::Titles" do
  it "has the constant regex TITLES" do
    expect(Nomener::Titles::TITLES).to be_a_kind_of(Regexp)
  end
end