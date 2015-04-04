require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end if ENV["COVERAGE"]

require 'nomener'
require 'bundler/setup'

RSpec.configure do |config|
  config.mock_with :rspec
  config.formatter = :progress
  config.raise_errors_for_deprecations!
  config.order = 'random'
end
