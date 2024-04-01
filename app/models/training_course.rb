# frozen_string_literal: true

class TrainingCourse < ApplicationRecord
  # belongs_to :training_enrollment
  attribute :course_id, :integer
  #belongs_to :training_enrollment, :class_name => 'TrainingEnrollment', :foreign_key => 'course_id'
  #has_many :training_enrollments
end
