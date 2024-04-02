# frozen_string_literal: true

class AttendanceRecord < ApplicationRecord
  # has_many :users
  # has_many :scheduled_workdays
  require 'csv'

  def self.create_record(workday)
    AttendanceRecord.create!(
      user_id: current_user.uid,
      schedule_id: workday.id,
      project_id: workday.project_id,
      checkin: Time.zone.now,
      approval_status: false
    )
  end

  def self.to_csv(attend_attributes = column_names, user_attributes = user.column_names, proj_id = passed_id1, sched_id = passed_id2, options = {})
    CSV.generate do |csv|
      csv << user_attributes + attend_attributes
      where(project_id: proj_id, schedule_id: sched_id).each do |attendance|
        user = User.find_by(uid: attendance.user_id)
        values = user.attributes.slice(*user_attributes).values
        puts user.attributes.slice(*user_attributes).values
        puts "hmm"
        values += attendance.attributes.slice(*attend_attributes).values
        csv << values
      end
    end
  end
end
