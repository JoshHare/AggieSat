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
      proj = Project.find_by(project_id: proj_id);
      members = ProjectMember.where(project_id: proj_id).pluck(:user_id)
      User.where(uid: members).sort_by{|member| member.full_name.split.last}.each do |user|
        first_name, *rest_of_name = user.full_name.split
        last_name = rest_of_name.pop 
        if rest_of_name.any? 
          middle_name = rest_of_name.join(' ')
        end
        if(middle_name.present?)
          values = ["#{last_name}, #{first_name} #{middle_name}"]
        else 
          values = ["#{last_name}, #{first_name}"]
        end 

        valid = false
        attendance = where(project_id: proj_id, schedule_id: sched_id, user_id: user.uid)
        if attendance.present?
          valid = true 
        end
        values += [valid]
        csv << values
      end 
      
    end
  end
end
