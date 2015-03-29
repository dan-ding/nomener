require 'spec_helper'

RSpec.describe "Complex name parsing" do
  context "with the names" do
    [
      { name: "Cecil de De la Smith", result: { first: "Cecil", last: "de De la Smith"} },
      { name: "Cecil Van Der Horn", result: { first: "Cecil", last: "Van Der Horn"} },
      { name: "Cecil De La Hoya", result: { first: "Cecil", last: "De La Hoya"} },
      { name: "Cecil McIntosh", result: { first: "Cecil", last: "McIntosh"} },
      { name: "Gavan O'Herlihy", result: { first: "Gavan", last: "O'Herlihy"} },
      { name: "Gavan Ó Herlihy", result: { first: "Gavan", last: "Ó Herlihy"} },
      { name: "Gerard Van 't Hooft", result: { first: "Gerard", last: "Van 't Hooft"} },
      { name: "Gerard 't Hooft", result: { first: "Gerard", last: "'t Hooft"} }
    ].each do |name|
      it "parses from #{name[:name]}" do
        parsed = Nomener.parse(name[:name])
        expect(parsed.first).to eq name[:result][:first]
        expect(parsed.last).to eq name[:result][:last]
      end
    end

  end
end