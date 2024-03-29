class ChangeColumnValue < ActiveRecord::Migration[7.1]
  def change
    # Change 'table_name' and 'column_name' to match your table and column
    change_column :attendance_records, :user_id, :string
  end
end
