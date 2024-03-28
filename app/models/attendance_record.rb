# frozen_string_literal: true

class AttendanceRecord < ApplicationRecord
  # has_many :users
  # has_many :scheduled_workdays
  def self.create_record(workday)
    AttendanceRecord.create!(
      user_id: current_user.uid,
      schedule_id: workday.id,
      project_id: workday.project_id,
      checkin: Time.now,
      approval_status: false
    )
  end
end