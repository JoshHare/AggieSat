class CreateAttendanceRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :attendance_records do |t|
      t.integer :user_id
      t.integer :schedule_id
      t.datetime :checkin
      t.boolean :approval_status

      t.timestamps
    end
  end
end
