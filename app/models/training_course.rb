# frozen_string_literal: true

class TrainingCourse < ApplicationRecord
  # belongs_to :training_enrollment
  attribute :course_id, :integer
  #belongs_to :training_enrollment, :class_name => 'TrainingEnrollment', :foreign_key => 'course_id'
  #has_many :training_enrollments

  require 'csv'

  def self.to_csv(name_attribute = user.column_names, options = {})
    CSV.generate do |csv|
      csv << name_attribute + %w(validity)

      User.all.each do |user|
        values = user.attributes.slice(*name_attribute).values 
        valid = true
        TrainingCourse.all.each do |course|
          str = TrainingService.check_enrollment_and_validity(course, user)
          if(str == "No enrollment" || str == "Expired!")
            valid = false
            break 
          end
        end
        values += [valid]
        csv << values
      end 
    end 
  end
end
