require 'spec_helper'

RSpec.describe "Name Parsing" do
  context "with the name from first to last" do
    [
      "Bertrand Russell",
      "Bertrand Arthur Russell",
      "Bertrand Arthur William Russell",
      "Bertrand A. William Russell",
      "B. A. William Russell",
      "Bertrand A W Russell"
    ].each do |name|
      it "parses #{name}" do
        parsed = Nomener.parse(name)
        expect(parsed.first[0]).to eq "B"
        expect(parsed.last[0]).to eq "R"
        expect(parsed.middle[0]).to eq "A" unless (parsed.middle.nil? || parsed.middle.empty?)
      end
    end
  end

end


