class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.integer :leader_id
      t.string :team_name

      t.timestamps
    end
  end
end
