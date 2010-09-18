module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
------------------------------------------------------ Multiple choices:

<% format_elements( qualified_methods.map { |m| m + ', ' } ).each do |row| %>
    <%= row.join %>
<% end %>
    EOT

    CLASS_DESCRIPTION =<<-EOT
<%= hrule( type + ": " + name ) %>
<% if description_paragraphs.empty? %>
  (no description...)
<% else %>
<% description_paragraphs.each do |paragraph| %>
<%= array_to_width( paragraph.split( /\s+/ ), 72, " ") %>
<% end %>
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
  ------------------------------------------------- <%= method.module %><%= method.separator %><%= method.name %>
       <%= method.name %>(<%= method.arglist %>)
  ------------------------------------------------------------------------
       <%= method.comment %>

    EOT

    module Helpers
      def hrule( text = '', width = Bri::WIDTH )
        '-' * ( width - text.length - 1 ) + " " + 
          Term::ANSIColor::bold + text + Term::ANSIColor::reset + 
          "\n"
      end

      def section_header( text )
        Term::ANSIColor::green + Term::ANSIColor::underline + text + Term::ANSIColor::reset + "\n"
      end

      def array_to_width( array, width = Bri::WIDTH, separator = ", " )
        indentation = '  '
        rows = '' + indentation
        row = ''
        row_length = 0

        array = add_separators( array, separator )

        array.each do |element|
          if row.length + element.length >= width
            rows << row + "\n" + indentation
            row = ''
          end

          row << element
        end

        rows << row
        rows
      end

      def add_separators( array, separator )
        last_element = array.pop
        array.map { |e| e + separator } + [ last_element ]
      end
    end
  end
end
