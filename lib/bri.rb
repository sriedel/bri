$: << File.dirname( __FILE__ )
require 'bri/matcher'

module Bri
  def self.ri( query )
    results = Bri::Matcher.find( query )

    if results.size == 0
      "No matching results found"
    end
  end
end

