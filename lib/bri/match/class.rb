require 'rdoc/markup'
require 'rdoc/markup/paragraph'

module Bri
  module Match
    class Class < Base
      include Bri::Templates::Helpers
      TEMPLATE = Bri::Templates::CLASS_DESCRIPTION

      attr_reader :type, :name, :description_paragraphs,
                  :includes, :extends, :constants, :class_methods,
                  :instance_methods, :attributes, :origin

      def initialize( rdoc_result, store = nil )
        class_methods, instance_methods = rdoc_result.method_list.
                                                      select {|m| m.visibility == :public }.
                                                      partition { |m| m.singleton }
        @type                   = rdoc_result.type
        @name                   = "#{rdoc_result.full_name}"
        @name                   << " < #{rdoc_result.superclass}" if @type == "class"
        @description_paragraphs = build_description( rdoc_result.comment.parts )
        @includes               = rdoc_result.includes.collect { |i| i.full_name }
        @extends                = rdoc_result.extends.collect { |i| i.full_name }
        @attributes             = rdoc_result.attributes.collect { |a| "#{a.name} (#{a.rw})" }
        @class_methods          = class_methods.collect { |m| m.name }
        @instance_methods       = instance_methods.collect { |m| m.name }
        @origin                 = store ? store.friendly_path : nil
        @constants = rdoc_result.constants.map do |c|
                       c.value ? "#{c.name} = #{c.value}" : c.name
                     end
      end
    end
  end
end
