$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "rein"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a
    # real object. This is generally recommended, and will default to `true` in
    # RSpec 4.
    mocks.verify_partial_doubles = false
  end
end
