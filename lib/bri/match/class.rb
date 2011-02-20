require 'rdoc/markup'
require 'rdoc/markup/paragraph'

module Bri
  module Match
    class Class < Base
      include Bri::Templates::Helpers
      TEMPLATE = Bri::Templates::CLASS_DESCRIPTION

      attr_reader :type, :name, :description_paragraphs
      attr_reader :includes, :constants, :class_methods, :instance_methods
      attr_reader :attributes

      def initialize( rdoc_result )
        @type = rdoc_result.type
        @name = rdoc_result.full_name
        @description_paragraphs = build_description( rdoc_result.comment.parts )
        @includes = rdoc_result.includes.collect { |i| i.full_name }
        @constants = rdoc_result.constants.collect do |c|
                       c.value ? "#{c.name} = #{c.value}" : c.name
                     end
        @attributes = rdoc_result.attributes.collect { |a| "#{a.name} (#{a.rw})" }

        class_methods, instance_methods = rdoc_result.method_list.
                                                      select {|m| m.visibility == :public }.
                                                      partition { |m| m.singleton }
        @class_methods = class_methods.collect { |m| m.name }
        @instance_methods = instance_methods.collect { |m| m.name }
      end

    end
  end
end
