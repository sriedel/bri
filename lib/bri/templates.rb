module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
<%= Bri::Templates::Helpers.hrule( "Multiple choices:" ) %>

<%= Bri::Templates::Helpers.array_to_width( qualified_methods.sort ) %>


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
<%= array_to_width( includes.sort ) %>


<% end %>
<% if !constants.empty? %>
<%= section_header( "Constants:" ) %>
<%= array_to_width( constants.sort ) %>


<% end %>
<% if !class_methods.empty? %>
<%= section_header( "Class methods:" ) %>
<%= array_to_width( class_methods.sort ) %>


<% end %>
<% if !instance_methods.empty? %>
<%= section_header( "Instance methods:" ) %>
<%= array_to_width( instance_methods.sort ) %>


<% end %>
<% if !attributes.empty? %>
<%= section_header( "Attributes:" ) %>
<%= array_to_width( attributes.sort ) %>


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
          '-' * ( width - text.length ) + 
            Term::ANSIColor::bold + text + Term::ANSIColor::reset + 
            "\n"
        end
      end
      module_function :hrule

      def section_header( text )
        Term::ANSIColor::green + Term::ANSIColor::underline + text + Term::ANSIColor::reset + "\n"
      end
      module_function :section_header

      def array_to_width( array, width = Bri.width, separator = ", ", indent_steps = 1 )
        indentation = '  '
        rows = '' + indentation * indent_steps
        row = ''
        row_length = 0

        array = add_separators( array, separator )

        array.compact.each do |element|
          if row.length + element.length >= width
            rows << row + "\n" + indentation * indent_steps
            row = ''
          end

          row << element
        end

        rows << row
        rows
      end
      module_function :array_to_width

      def add_separators( array, separator )
        last_element = array.pop
        array.map { |e| e + separator } + [ last_element ]
      end
      module_function :add_separators
    end
  end
end
