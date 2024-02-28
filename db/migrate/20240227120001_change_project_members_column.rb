class ChangeProjectMembersColumn < ActiveRecord::Migration[7.1]
    def change
        change_column :project_members, :user_id, :string
    end
end
  