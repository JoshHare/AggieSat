# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Rails.logger.debug('Clearing existing data...')
User.destroy_all
TrainingCourse.destroy_all
TrainingEnrollment.destroy_all
Project.destroy_all
ScheduledWorkday.destroy_all
AttendanceRecord.destroy_all
ProjectMember.destroy_all


User.create!([{
    uid: "24",
    avatar_url: "testing",
    full_name: "Christian Mosquera",
    role: "Admin",
    email: "cwbo.1701@tamu.edu"
  },
  {
    uid: "25",
    avatar_url: "testing",
    full_name: "Joshua Hare",
    role: "Admin",
    email: "jmhhare@tamu.edu"
  },
  {
    uid: "26",
    avatar_url: "testing",
    full_name: "Lucy Zhang",
    role: "Admin",
    email: "lululilly1212@tamu.edu"
  },
  {
    uid: "27",
    avatar_url: "testing",
    full_name: "Adidev Mohapatra",
    role: "Member",
    email: "adidev@tamu.edu"
  },
  {
    uid: "28",
    avatar_url: "testing",
    full_name: "Daniela Martinis",
    role: "Member",
    email: "daniela.martinis@tamu.edu"
  }
])

puts "Created #{User.count} Users"

TrainingCourse.create!([{
    name: "Export Controls & Embargo Training - Basic Course",
    course_id: 2111212
  },
  {
    name: "Export Controls - Technology Control Plans",
    course_id: 2111873
  },
  {
    name: "Laboratory Safety Training (Online) - EHS",
    course_id: 2114106
  },
  {
    name: "Fire Safety for the Laboratory - EHS",
    course_id: 2112861
  },
  {
    name: "Hazard Communication",
    course_id: 11020
  }
])

puts "Created #{TrainingCourse.count} Training Coureses"

TrainingEnrollment.create!([{
    course_id: 2112861,
    user_id: 1,
    completion_status: "2023-09-03 00:00:00"
  },
  {
    course_id: 11020,
    user_id: 1,
    completion_status: "2023-10-03 00:00:00"
  },
  {
    course_id: 2111873,
    user_id: 1,
    completion_status: "2023-09-03 00:00:00"
  },
  {
    course_id: 2112861,
    user_id: 2,
    completion_status: "2023-09-06 00:00:00"
  },
  {
    course_id: 11020,
    user_id: 2,
    completion_status: "2023-08-21 00:00:00"
  },
  {
    course_id: 2112861,
    user_id: 2,
    completion_status: "2023-11-14 00:00:00"
  },
  {
    course_id: 2112861,
    user_id: 3,
    completion_status: "2023-08-14 00:00:00"
  },
  {
    course_id: 2111212,
    user_id: 3,
    completion_status: "2023-11-15 00:00:00"
  },
  {
    course_id: 2111212,
    user_id: 4,
    completion_status: "2023-10-17 00:00:00"
  },
  {
    course_id: 2111212,
    user_id: 5,
    completion_status: "2023-11-12 00:00:00"
  }
])

puts "Created #{TrainingEnrollment.count} Training Enrollments"
