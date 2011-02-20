module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
<%= Bri::Templates::Helpers.hrule( "Multiple choices:" ) %>

<%= Bri::Renderer.wrap_list( qualified_methods.sort ) %>


    EOT

    CLASS_DESCRIPTION =<<-EOT
<%= hrule( type + ": " + name ) %>
<% if description_paragraphs.empty? %>
  (no description...)
<% else %>
<%= description_paragraphs.join("\n" ) %>
<% end %>

<%= hrule %>

<% if !includes.empty? %>
<%= section_header( "Includes:" ) %>
<%= Bri::Renderer.wrap_list( includes.sort ) %>


<% end %>
<% if !constants.empty? %>
<%= section_header( "Constants:" ) %>
<%= Bri::Renderer.wrap_list( constants.sort ) %>


<% end %>
<% if !class_methods.empty? %>
<%= section_header( "Class methods:" ) %>
<%= Bri::Renderer.wrap_list( class_methods.sort ) %>


<% end %>
<% if !instance_methods.empty? %>
<%= section_header( "Instance methods:" ) %>
<%= Bri::Renderer.wrap_list( instance_methods.sort ) %>


<% end %>
<% if !attributes.empty? %>
<%= section_header( "Attributes:" ) %>
<%= Bri::Renderer.wrap_list( attributes.sort ) %>


<% end %>
    EOT

    METHOD_DESCRIPTION =<<-EOT
<%= hrule( full_name ) %>
<%= call_syntaxes %>
<%= hrule %>
<% if description_paragraphs.empty? %>
  (no description...)
<% else %>
<%= description_paragraphs.join( "\n" ) %>
<% end %>

    EOT

    module Helpers
      def hrule( text = '', width = Bri.width )
        if text == ''
          '-' * width + "\n"
        else
          text = " " + text if text != ''
          ( '-' * [ ( width - text.length ), 1 ].max ) + Term::ANSIColor::bold( text ) + "\n"
        end
      end
      module_function :hrule

      def section_header( text )
        Term::ANSIColor::green + Term::ANSIColor::underline + text + Term::ANSIColor::reset + "\n"
      end
      module_function :section_header
    end
  end
end
