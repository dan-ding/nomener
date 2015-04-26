#-- encoding: UTF-8
require 'nomener/configuration'
require 'nomener/name'
require 'nomener/version'

# Base module for our names
module Nomener
  # hold the configuration object Nomener::Configuration
  @@config = nil

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

  # Public: to configure the Nomener object
  #   can set individually or by block
  #   See Nomener::Configuration for more details on what may be set
  #
  # Returns the configuration object
  def self.configure
    @@config ||= Nomener::Configuration.new
    yield config if block_given?
    @@config
  end

  # Public: set the configuration to the Nomener::Configuration defaults
  #
  # Returns the configuration object
  def self.reset
    @@config = Nomener::Configuration.new
  end

  # Internal: Read accessor for configuration
  #
  # Returns the configuration
  def self.config
    self.configure unless @@config
    @@config
  end
end
