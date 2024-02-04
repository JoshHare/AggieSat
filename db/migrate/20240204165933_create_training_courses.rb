class CreateTrainingCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :training_courses do |t|
      t.string :name

      t.timestamps
    end
  end
end
