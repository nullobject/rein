ENV["REIN_ENV"] ||= "development"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rein/alone'
require 'rr'
require 'spec'

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
