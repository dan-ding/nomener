require 'nomener'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.mock_with :rspec
  config.formatter = :documentation
  config.raise_errors_for_deprecations!
  config.order = 'random'
end
