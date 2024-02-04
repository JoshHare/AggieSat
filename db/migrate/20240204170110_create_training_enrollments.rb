class CreateTrainingEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :training_enrollments do |t|
      t.integer :course_id
      t.integer :user_id
      t.datetime :completion_status

      t.timestamps
    end
  end
end
