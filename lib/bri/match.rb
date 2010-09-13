module Bri
  class Match
    attr_reader :class_name, :method_name, :method_type

    def initialize( class_name, method_name, method_type )
      @class_name = class_name
      @method_name = method_name
      @method_type = method_type
    end

    def qualified_name
      "#{@class_name}#{separator}#{@method_name}"
    end

    def separator
      case @method_type
        when :class_method then "."
        when :instance_method then "#"
        else raise "Unknown method type #{method_type}"
      end
    end

  end
end
