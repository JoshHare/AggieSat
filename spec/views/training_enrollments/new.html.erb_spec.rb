<%= link_to("Back to List", '#', :class => 'back-link') %>

<div class="tasks new">
  <h2>Create Task</h2>

  <%= form_for(@enrollment) do |f| %>
    <% # url: tasks_path, method: 'post' %>

    <%= render(partial:'form', locals:{f:f}) %>

    <div class="form-buttons">
      <%= f.submit("Create Task") %>
    </div>

  <% end %>
</div>
