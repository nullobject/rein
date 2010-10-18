ENV["REIN_ENV"] ||= "development"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rein/alone'
require 'rr'
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rr
end

# FIXME: this is a workaround to get RSpec 2 to play nicely with RR.
require 'rr/adapters/rspec'
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
