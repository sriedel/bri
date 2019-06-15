require 'rspec/its'
require_relative '../lib/bri'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = [ :should, :expect ]
  end

  config.expect_with :rspec do |expect|
    expect.syntax = [ :should, :expect ]
  end

  config.order = :random
  Kernel.srand config.seed
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

puts "Regenerating ri document cache"
output_path = File.join( __dir__, 'ri' )
class_file = File.join( __dir__, 'bri_dummy_spec_class.rb' )
%x{rdoc --ri #{class_file}}
