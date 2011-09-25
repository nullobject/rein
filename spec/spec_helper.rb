require "rr"
require "rr/adapters/rspec"
require "rspec"
require "simplecov"

SimpleCov.start

require "rein"

RSpec.configure do |config|
  config.mock_with :rr
end

# FIXME: This is a workaround to get RSpec 2 to play nicely with RR.
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
