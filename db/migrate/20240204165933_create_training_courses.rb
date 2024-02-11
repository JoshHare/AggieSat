class CreateTrainingCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :training_courses do |t|
      t.string :name
      t.integer :course_id

      t.timestamps
    end
  end
end
