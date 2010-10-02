module Bri
  module Match
    class Method < Base
      include Bri::Templates::Helpers
      TEMPLATE = Bri::Templates::METHOD_DESCRIPTION

      attr_accessor :full_name, :call_syntaxes, :description_paragraphs

      def initialize( rdoc_method )
        @full_name = rdoc_method.full_name
        @call_syntaxes = rdoc_method.arglists.split( "\n" ).
                                              map { |e| "  " + e }.
                                              join( "\n" ) + "\n" rescue ''
        @description_paragraphs = build_description( rdoc_method.comment.parts )
      end
    end
  end
end
