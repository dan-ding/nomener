#-- encoding: UTF-8
require 'nomener/version'
require 'nomener/name'

# Base module for our names
module Nomener
  # Error class raised for the few times we aren't able to parse a name
  class ParseError < StandardError
  end

  # Public: Convenience method to parse a name
  #
  # name - a string of a name to parse
  #
  # Returns a <Nomener::Name> or nil if it couldn't be parsed
  def self.parse(name)
    Name.new(name).parse
  end
end
