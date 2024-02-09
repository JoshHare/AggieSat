class ScheduledWorkday < ApplicationRecord
  # this is the program manager
  has_one :user
  belongs_to :attendance_record
end
