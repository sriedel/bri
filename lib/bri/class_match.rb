require 'rdoc/markup'
require 'rdoc/markup/paragraph'

module Bri
  class ClassMatch
    attr_reader :type, :name, :description_paragraphs
    attr_reader :includes, :constants, :class_methods, :instance_methods
    attr_reader :attributes

    def initialize( rdoc_result )
      @type = rdoc_result.type
      @name = rdoc_result.name
      @description_paragraphs = rdoc_result.comment.parts.collect { |p| p.parts.join }
      @includes = rdoc_result.includes.collect { |i| i.full_name }
      @constants = rdoc_result.constants.collect { |c| { :name => c.name,
                                                         :value => c.value } }
      @attributes = rdoc_result.attributes.collect { |a| "#{a.name} (#{a.rw})" }
      @class_methods = "IMPLEMENT ME"
      @instance_methods = "IMPLEMENT ME"
    end
  end
end
