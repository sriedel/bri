module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
<%= hrule( "Multiple choices:" ) %>

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
<%= wrap_list( includes.sort ) %>


<% end %>
<% if !extends.empty? %>
<%= section_header( "Extends:" ) %>
<%= wrap_list( extends.sort ) %>


<% end %>
<% if !constants.empty? %>
<%= section_header( "Constants:" ) %>
<%= wrap_list( constants.sort ) %>


<% end %>
<% if !class_methods.empty? %>
<%= section_header( "Class methods:" ) %>
<%= wrap_list( class_methods.sort ) %>


<% end %>
<% if !instance_methods.empty? %>
<%= section_header( "Instance methods:" ) %>
<%= wrap_list( instance_methods.sort ) %>


<% end %>
<% if !attributes.empty? %>
<%= section_header( "Attributes:" ) %>
<%= wrap_list( attributes.sort ) %>


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
  end
end
