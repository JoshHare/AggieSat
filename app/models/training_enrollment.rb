# frozen_string_literal: true

class TrainingEnrollment < ApplicationRecord
  # has_many :users
  # has_one :training_course
  #belongs_to :training_course

  require 'csv'

  def self.to_csv(train_attributes = column_names, name_attribute = training_courses.column_names, id = passed_id, options = {})
    CSV.generate do |csv|
      csv << train_attributes + name_attribute
      where(user_id: id).each do |training|
        values = training.attributes.slice(*train_attributes).values

        if training.course_id
          training_course = TrainingCourse.find_by(course_id: training.course_id)
          values += training_course.attributes.slice(*name_attribute).values
        end

        csv << values
      end
    end
  end
end
