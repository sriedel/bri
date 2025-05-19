module Bri
  module Match
    class Method < Base
      include Bri::Templates::Helpers
      TEMPLATE = Bri::Templates::METHOD_DESCRIPTION

      attr_accessor :full_name, :call_syntaxes, :description_paragraphs, :origin

      def initialize( rdoc_method, store = nil )
        @full_name = rdoc_method.full_name
        @call_syntaxes = rdoc_method.arglists.lines( chomp: true ).
                                              map { |e| e.prepend( "  " ) }.
                                              join( "\n" ) + "\n" rescue ''

        document = rdoc_method.comment.instance_variable_get( :@document )
        @description_paragraphs = build_description( document.parts )
        @origin = store&.friendly_path
      end
    end
  end
end
