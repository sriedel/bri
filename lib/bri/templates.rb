module Bri
  module Templates
    RULE_CHARACTER = '-'.freeze

    MULTIPLE_CHOICES =<<-EOT
<%= Bri::Templates::Helpers.hrule( "Multiple choices:" ) %>

<%= qualified_methods.sort.join("\n") %>


    EOT

    CLASS_DESCRIPTION =<<-EOT
<%= hrule( type + ": " + name ) %>
<%= print_origin( origin ) %>

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
<% if !extends.empty? %>
<%= section_header( "Extends:" ) %>
<%= Bri::Renderer.wrap_list( extends.sort ) %>


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
<%= print_origin( origin ) %>

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
        text.prepend( " " ) unless text.empty?

        rule_length = width - text.length
        rule_length = 1 if rule_length < 1

        rule = RULE_CHARACTER * rule_length
        "#{rule}#{Term::ANSIColor::bold( text )}\n"
      end
      module_function :hrule

      def print_origin( origin_text, width = Bri.width )
        return unless origin_text
        "(#{origin_text})".rjust( width )
      end

      def section_header( text )
        "#{Term::ANSIColor.green}#{Term::ANSIColor.underline}#{text}#{Term::ANSIColor.reset}\n"
      end
      module_function :section_header
    end
  end
end
