class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :avatar_url
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :email

      t.timestamps
    end
  end
end
