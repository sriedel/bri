spec_root = File.dirname( __FILE__ )
require File.join( spec_root, '..', 'lib', 'bri.rb' )

puts "Regenerating ri document cache"
output_path = File.join( spec_root, 'ri' )
class_file = File.join( spec_root, 'bri_dummy_spec_class.rb' )
%x{rdoc --ri #{class_file}}
