module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
------------------------------------------------------ Multiple choices:

<% format_elements( qualified_methods.map { |m| m + ', ' } ).each do |row| %>
    <%= row.join %>
<% end %>
    EOT

    CLASS_DESCRIPTION =<<-EOT
----------------------------------------------- <%= type %>: <%= name %>
<% if description_paragraphs.empty? %>
  (no description...)
<% else %>
<% description_paragraphs.each do |paragraph| %>
<%= array_to_width( paragraph.split( /\s+/ ), 72, " ") %>
<% end %>
<% end %>

------------------------------------------------------------------------

<% if !includes.empty? %>
Includes:
<%= array_to_width( includes.sort ) %>


<% end %>
<% if !constants.empty? %>
Constants:
<%= array_to_width( constants.sort ) %>


<% end %>
<% if !class_methods.empty? %>
Class methods:
<%= array_to_width( class_methods.sort ) %>


<% end %>
<% if !instance_methods.empty? %>
Instance methods:
<%= array_to_width( instance_methods.sort ) %>


<% end %>
<% if !attributes.empty? %>
Attributes:
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
