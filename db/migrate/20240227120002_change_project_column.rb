class ChangeProjectColumn < ActiveRecord::Migration[7.1]
    def change
        change_column :projects, :leader_id, :string
    end
end
  