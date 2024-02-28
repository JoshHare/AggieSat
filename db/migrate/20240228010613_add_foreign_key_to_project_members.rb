class AddForeignKeyToProjectMembers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :project_members, :projects, column: :project_id, on_delete: :cascade
  end
end

