#-- encoding: UTF-8
require 'spec_helper'

RSpec.describe "Nomener::Cleaner" do
  context "with reformat" do
    it "returns the same string given" do
      expect(Nomener::Cleaner.reformat("Joe \"John\" O'Smith")).to eq "Joe \"John\" O'Smith"
    end
    it "returns the string with curved double quotes replaced" do
      expect(Nomener::Cleaner.reformat("Joe “John” O'Smith")).to eq "Joe \"John\" O'Smith"
    end
    it "returns the string with curved single quotes replaced" do
      expect(Nomener::Cleaner.reformat("Joe ‘John’ O'Smith")).to eq "Joe 'John' O'Smith"
    end
    it "returns the string with double angle quotes replaced" do
      expect(Nomener::Cleaner.reformat("Joe «John» O'Smith")).to eq "Joe \"John\" O'Smith"
    end
  end
end
