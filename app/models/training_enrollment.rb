class TrainingEnrollment < ApplicationRecord
  has_many :users
  has_many :training_courses
end
