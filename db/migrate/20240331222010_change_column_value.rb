class ChangeColumnValue < ActiveRecord::Migration[7.1]
  def change
    change_column :attendance_records, :user_id, :string
  end
end
