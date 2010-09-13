$: << File.dirname( __FILE__ )
require 'bri/matcher'

module Bri
  def self.ri( query )
    results = Bri::Matcher.find( query )

    if results.size == 0
      "No matching results found"
    elsif results.size == 1
    else
      output = []
      output << '------------------------------------------------------ Multiple choices:'
      output << ''
      output << results.join( ', ' )
      output.join( "\n" )
    end
  end
end

