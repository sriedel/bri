module Bri
  class Matcher
    def initialize( term )
      @term = term
    end

    def find
      search_instance = create_search_instance( subject, term )
      search_instance.search( type )
      search_instance.matches
    end

    def type
      case @term
        when /^[A-Z]/  then :fully_qualified
        when /^[_a-z]/ then :unqualified
        when /^[.#]/   then :partially_qualified
        else :error
      end
    end

    def subject
      case @term
        when /^[A-Z].*\./, /^\./   then :class_method
        when /^[A-Z].*#/,  /^#/    then :instance_method
        when /^[A-Z][^.#]*/        then :module
        else :method
      end
    end
  end
end
