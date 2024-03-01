class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.integer :project_id
      t.integer :leader_id
      t.string :project_name

      t.timestamps
    end
  end
end
