class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.integer :team_id
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :email

      t.timestamps
    end
  end
end