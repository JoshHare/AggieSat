class CreateScheduledWorkdays < ActiveRecord::Migration[7.1]
  def change
    create_table :scheduled_workdays do |t|
      t.integer :program_manager_id
      t.date :day

      t.timestamps
    end
  end
end
