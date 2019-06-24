require 'strscan'
require 'rdoc'
require 'rdoc/markup'

require_relative 'renderer/default'
require_relative 'renderer/blank_line'
require_relative 'renderer/document'
require_relative 'renderer/heading'
require_relative 'renderer/list_item'
require_relative 'renderer/list'
require_relative 'renderer/paragraph'
require_relative 'renderer/rule'
require_relative 'renderer/verbatim'
require_relative 'renderer/result'

module Bri
  module Renderer
    RDOC_TO_BRI_RENDERER_CLASS_MAP = {
      ::RDoc::Markup::Document  => ::Bri::Renderer::Document,
      ::RDoc::Markup::Paragraph => ::Bri::Renderer::Paragraph,
      ::RDoc::Markup::BlankLine => ::Bri::Renderer::BlankLine,
      ::RDoc::Markup::Rule      => ::Bri::Renderer::Rule,
      ::RDoc::Markup::Verbatim  => ::Bri::Renderer::Verbatim,
      ::RDoc::Markup::Heading   => ::Bri::Renderer::Heading,
      ::RDoc::Markup::ListItem  => ::Bri::Renderer::ListItem,
      ::RDoc::Markup::List      => ::Bri::Renderer::List,
    }
    RDOC_TO_BRI_RENDERER_CLASS_MAP.default = ::Bri::Renderer::Default

    INDENT = ' ' * 2
    INDENT_WIDTH = 2

    def self.new( element )
      renderer_class = RDOC_TO_BRI_RENDERER_CLASS_MAP[element.class]
      renderer_class.new( element )
    end

    def self.render( element, width = Bri.width )
      renderer_class = RDOC_TO_BRI_RENDERER_CLASS_MAP[element.class]
      renderer_class.new( element ).render( width )
    end

    def self.extract_text( element, width, conserve_newlines = false )
      renderer_class = RDOC_TO_BRI_RENDERER_CLASS_MAP[element.class]
      renderer_class.new( element ).extract_text( width, conserve_newlines  )
    end
  end
end
