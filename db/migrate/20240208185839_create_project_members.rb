class CreateProjectMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :project_members do |t|
      t.string :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end