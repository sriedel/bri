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
        @name                   << " < #{rdoc_result.superclass}" if @type == "class" && rdoc_result.superclass

        @description_paragraphs = build_description_from_comment( rdoc_result.comment )
        @includes               = rdoc_result.includes.map(&:full_name)
        @extends                = rdoc_result.extends.map(&:full_name)
        @attributes             = rdoc_result.attributes.map { |a| "#{a.name} (#{a.rw})" }
        @class_methods          = class_methods.map(&:name)
        @instance_methods       = instance_methods.map(&:name)
        @origin                 = store&.friendly_path
        @constants = rdoc_result.constants.map do |c|
                       c.value ? "#{c.name} = #{c.value}" : c.name
                     end
      end
    end
  end
end
