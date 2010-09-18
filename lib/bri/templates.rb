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

<% if includes %>
Includes:
<%= includes %>

<% end %>
<% if constants %>
Constants:
<%= constants %>

<% end %>
<% if class_methods %>
Class methods:
<%= class_methods %>

<% end %>
<% if instance_methods %>
Instance methods:
<%= instance_methods %>

<% end %>
<% if attributes %>
Attributes:
<%= attributes %>

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
