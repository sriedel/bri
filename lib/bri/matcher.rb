module Bri
  class Matcher
    SEPARATOR_RE = %r{[#.]}

    def initialize
      @mall = Bri::Mall.new
    end

    def find( term )
      case match_type( term )
        when :class
          
        when :qualified_method
        when :unqualified_method
          class_methods = match_methods( query, @mall.class_methods_by_class, :class_method )
          instance_methods = match_methods( query, @mall.instance_methods_by_class, :instance_method )
          class_methods + instance_methods
        else
          raise "Unknown match type"
      end
    end

    def match_type( term )
      case term
        when /^[A-Z]/  then :fully_qualified
        when /^[_a-z]/ then :unqualified
        when /^[.#]/   then :partially_qualified
        else :error
      end
    end

    def match_subject( term )
      case term
        when /^[A-Z].*\./, /^\./   then :class_method
        when /^[A-Z].*#/,  /^#/    then :instance_method
        when /^[A-Z][^.#]*/        then :module
        else :method
      end
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

    def match_partitions( term )
      class_name, method_name = term.split( SEPARATOR_RE, 2 )
    end

  end
end
