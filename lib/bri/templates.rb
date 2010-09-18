module Bri
  module Templates
    MULTIPLE_CHOICES =<<-EOT
------------------------------------------------------ Multiple choices:

<% format_elements( qualified_methods.map { |m| m + ', ' } ).each do |row| %>
    <%= row.join %>
<% end %>
    EOT

    CLASS_DESCRIPTION =<<-EOT
----------------------------------------------- <%= module.type %>: <%= module.name %>
<%= module.comment || "(no description...)" %>

------------------------------------------------------------------------

<% if module.includes %>
Includes:
<%= module.includes %>

<% end %>
<% if module.constants %>
Constants:
<%= module.constants %>

<% end %>
<% if module.class_methods %>
Class methods:
<%= module.class_methods %>

<% end %>
<% if module.instance_methods %>
Instance methods:
<%= module.instance_methods %>

<% end %>
<% if module.attributes %>
Attributes:
<%= module.attributes %>

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
