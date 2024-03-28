class CreateScheduledWorkdays < ActiveRecord::Migration[7.1]
  def change
    create_table :scheduled_workdays do |t|
      t.string :program_manager_id
      t.integer :project_id
      t.date :day

      t.timestamps
    end
  end
end
