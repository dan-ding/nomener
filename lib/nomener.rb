require "nomener/version"
require "nomener/name"
require "nomener/parser"

module Nomener

  class ParseError < StandardError; end
  
  # Public: Convenience method to parse a name
  #
  # name - a string of a name to parse
  #
  # Returns a <Nomener::Name> or nil if it couldn't be parsed
  def self.parse(name)
    Name.new(name).parse
  end

end
