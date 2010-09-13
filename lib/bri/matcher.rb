module Bri
  class Matcher
    def initialize
      @mall = Bri::Mall.new
    end

    def find( query )
      #TODO: add classes to the query
      #TODO: add increasingly lenient match methods like qri/fastri

      class_methods = match_methods( query, @mall.class_methods_by_class, :class_method )
      instance_methods = match_methods( query, @mall.instance_methods_by_class, :instance_method )

      class_methods + instance_methods
    end

    private
    def match_methods( term, methods_by_class, method_type )
      methods_by_class.collect do |class_name, methods|
        candidates = methods.grep( /#{Regexp.escape( term )}/i )

        candidates.collect do |candidate| 
          Bri::Match.new( class_name, candidate, method_type ) 
        end
      end.flatten
    end
  end
end
