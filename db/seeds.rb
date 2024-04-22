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

User.create!([
  {
    id: '25',
    uid: '25',
    avatar_url: 'testing',
    full_name: 'Skye Slaughter',
    role: 'Member',
    email: 'x@tamu.edu'

  },
  {
    id: '26',
    uid: '26',
    avatar_url: 'testing',
    full_name: 'Daniel Newsom',
    role: 'Member',
    email: 'x@tamu.edu'

  },
  {
    id: '27',
    uid: '27',
    avatar_url: 'testing',
    full_name: 'Shirish Pandam',
    role: 'Member',
    email: 'x@tamu.edu'
  },
  {
    id: '28',
    uid: '28',
    avatar_url: 'testing',
    full_name: 'Azalea Andrews',
    role: 'Member',
    email: 'x@tamu.edu'
  },
  {
    id: '29',
    uid: '29',
    avatar_url: 'testing',
    full_name: 'Lexi Urquhart',
    role: 'Member',
    email: 'x@tamu.edu'
  },
  {
    id: '30',
    uid: '30',
    avatar_url: 'testing',
    full_name: 'Kamalika Bose',
    role: 'Member',
    email: 'x@tamu.edu'

  },
  {
    id: '31',
    uid: '31',
    avatar_url: 'testing',
    full_name: 'Tate Crawford',
    role: 'Member',
    email: 'x@tamu.edu'
  },
  {
    uid: '32',
    avatar_url: 'testing',
    full_name: 'Joshua Hare',
    role: 'Admin',
    email: 'jmhhare@tamu.edu'
  },
  {
    uid: '33',
    avatar_url: 'testing',
    full_name: 'Lucy Zhang',
    role: 'Admin',
    email: 'lululilly1212@tamu.edu'
  },
  {
    uid: '34',
    avatar_url: 'testing',
    full_name: 'Adidev Mohapatra',
    role: 'Admin',
    email: 'adidev@tamu.edu'
  },
  {
    uid: '35',
    avatar_url: 'testing',
    full_name: 'Daniela Martinis',
    role: 'Admin',
    email: 'daniela.martinis@tamu.edu'
  },
  {
    id: '36',
    uid: '36',
    avatar_url: 'testing',
    full_name: 'amy bob',
    role: 'Member',
    email: 'amybob@tamu.edu'
  },
  {
    uid: '37',
    avatar_url: 'testing',
    full_name: 'Christian Mosquera',
    role: 'Admin',
    email: 'cwbo.1701@tamu.edu'
  },
  {
    id: '38',
    uid: '38',
    avatar_url: 'testing',
    full_name: 'amy bob 2',
    role: 'Admin',
    email: 'amybob2@tamu.edu'
  },
  {
    id: '39',
    uid: '39',
    avatar_url: 'testing',
    full_name: 'vishal',
    role: 'Admin',
    email: 'vva2@tamu.edu'
  },
  {
    id: '40',
    uid: '40',
    avatar_url: 'testing',
    full_name: 'dr wade',
    role: 'Admin',
    email: 'paulinewade@tamu.edu'
  }
]
            )
Rails.logger.debug { "Created #{User.count} Users" }

TrainingCourse.create!([
  {
    name: 'Export Controls & Embargo Training - Basic Course',
    course_id: 2_111_212
  },
  {
    name: 'Export Controls - Technology Control Plans',
    course_id: 2_111_873
  },
  {
    name: 'Laboratory Safety Training (Online) - EHS',
    course_id: 2_114_106
  },
  {
    name: 'Fire Safety for the Laboratory - EHS',
    course_id: 2_112_861
  },
  {
    name: 'Hazard Communication',
    course_id: 11_020
  }
]
                      )

Rails.logger.debug { "Created #{TrainingCourse.count} Training Coureses" }

TrainingEnrollment.create!([
  {
    course_id: 2_112_861,
    user_id: 1,
    completion_status: '2023-09-03 00:00:00'
  },
  {
    course_id: 11_020,
    user_id: 1,
    completion_status: '2023-10-03 00:00:00'
  },
  {
    course_id: 2_111_873,
    user_id: 1,
    completion_status: '2023-09-03 00:00:00'
  },
  {
    course_id: 2_112_861,
    user_id: 2,
    completion_status: '2023-09-06 00:00:00'
  },
  {
    course_id: 11_020,
    user_id: 2,
    completion_status: '2023-08-21 00:00:00'
  },
  {
    course_id: 2_112_861,
    user_id: 2,
    completion_status: '2023-11-14 00:00:00'
  },
  {
    course_id: 2_112_861,
    user_id: 3,
    completion_status: '2023-08-14 00:00:00'
  },
  {
    course_id: 2_111_212,
    user_id: 3,
    completion_status: '2023-11-15 00:00:00'
  },
  {
    course_id: 2_111_212,
    user_id: 4,
    completion_status: '2023-10-17 00:00:00'
  },
  {
    course_id: 2_111_212,
    user_id: 5,
    completion_status: '2023-11-12 00:00:00'
  },
  {
    course_id: 2_111_212,
    user_id: 9,
    completion_status: '2023-11-12 00:00:00'
  }
]
                          )

Rails.logger.debug { "Created #{TrainingEnrollment.count} Training Enrollments" }

Project.create!([
  {
    id: 3,
    project_id: 3,
    leader_id: '25',
    project_name: 'AGS6'
  },
  {
    id: 4,
    project_id: 4,
    leader_id: '26',
    project_name: 'CCT'
  },
  {
    id: 5,
    project_id: 5,
    leader_id: '27',
    project_name: 'REGS'
  },
  {
    id: 6,
    project_id: 6,
    leader_id: '28',
    project_name: 'AR1'
  },
  {
    id: 7,
    project_id: 7,
    leader_id: '29',
    project_name: 'GeoRGE'
  },
  {
    id: 8,
    project_id: 8,
    leader_id: '30',
    project_name: 'SOLACE'
  },
  {
    id: 9,
    project_id: 9,
    leader_id: '104940125384065754825',
    project_name: 'REV-2'
  },
  {
    id: 10,
    project_id: 10,
    leader_id: '38',
    project_name: 'Juniper'
  }
]
               )

Rails.logger.debug { "Created #{Project.count} Projects" }

ProjectMember.create!([
  {
    user_id: '111619080521840803157',
    project_id: 3
  },
  {
    user_id: '111619080521840803157',
    project_id: 4
  },
  {
    user_id: '111619080521840803157',
    project_id: 5
  },
  {
    user_id: '111619080521840803157',
    project_id: 6
  },
  {
    user_id: '111619080521840803157',
    project_id: 7
  },
  {
    user_id: '111619080521840803157',
    project_id: 8
  },
  {
    user_id: '111619080521840803157',
    project_id: 9
  },
  {
    user_id: '111619080521840803157',
    project_id: 10
  },
  {
    user_id: '25',
    project_id: 3
  },
  {
    user_id: '26',
    project_id: 4
  },
  {
    user_id: '27',
    project_id: 5
  },
  {
    user_id: '28',
    project_id: 6
  },
  {
    user_id: '29',
    project_id: 7
  },
  {
    user_id: '30',
    project_id: 8
  },
  {
    user_id: '31',
    project_id: 9
  },
  {
    user_id: '104940125384065754825',
    project_id: 9
  }
]
                     )

Rails.logger.debug { "Created #{ProjectMember.count} Project Members" }

ScheduledWorkday.create!([
  {
    program_manager_id: '25',
    project_id: 3,
    day: Time.zone.today
  },
  {
    program_manager_id: '25',
    project_id: 3,
    day: Time.zone.today + 1
  },
  {
    program_manager_id: '25',
    project_id: 3,
    day: Time.zone.today + 2
  },
  {
    program_manager_id: '111619080521840803157',
    project_id: 10,
    day: Time.zone.today
  },
  {
    program_manager_id: '111619080521840803157',
    project_id: 10,
    day: Time.zone.today + 1
  },
  {
    program_manager_id: '111619080521840803157',
    project_id: 10,
    day: Time.zone.today + 4
  },
  {
    program_manager_id: '111619080521840803157',
    project_id: 10,
    day: Time.zone.today - 5
  }
]
                        )
