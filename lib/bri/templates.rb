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
<%= description_paragraphs.join("\n\n") || "(no description...)" %>

------------------------------------------------------------------------

<% if !includes.empty? %>
Includes:
<%= includes.sort.join(", ") %>


<% end %>
<% if !constants.empty? %>
Constants:
<%= constants.sort.join( ", ") %>


<% end %>
<% if !class_methods.empty? %>
Class methods:
<%= class_methods.sort.join(", ") %>


<% end %>
<% if !instance_methods.empty? %>
Instance methods:
<%= instance_methods.sort.join( ", ") %>


<% end %>
<% if !attributes.empty? %>
Attributes:
<%= attributes.sort.join( ", " ) %>


<% end %>
    EOT
  end

  METHOD_DESCRIPTION =<<-EOT
------------------------------------------------- <%= method.module %><%= method.separator %><%= method.name %>
     <%= method.name %>(<%= method.arglist %>)
------------------------------------------------------------------------
     <%= method.comment %>

  EOT
end
