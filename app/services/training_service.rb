# frozen_string_literal: true

# app/services/training_service.rb

class TrainingService
  # collects names of students who are not up to date on their training and sends the CSL an email
  def self.send_training_report
    expired = ''
    User.all.find_each do |user|
      expired << "#{user.full_name}<br>" if generate_training_report(user)
    end

    if expired.present?
      TrainingNotificationMailer.training_report(expired).deliver_now
    else
      TrainingNotificationMailer.training_report('All students up to date').deliver_now
    end
  end

  def self.generate_training_report(user)
    TrainingCourse.all.find_each do |course|
      result = check_enrollment_and_validity(course, user)
      return true if ['Expired', 'No enrollment'].include?(result)
    end
    false
  end

  # itereate through each user and check if an email needs to be sent

  def self.send_emails_for_overdue_trainings
    User.all.find_each do |user|
      send_email_if_overdue(user)
    end
  end

  # for a user, iterate through each training course and evaluate the type of email that needs to be sent.

  def self.send_email_if_overdue(user)
    email_content = ''
    null_content = ''
    warning_content = ''

    # iterate through each required course from training course database
    TrainingCourse.all.find_each do |course|
      Rails.logger.debug(user.email)
      Rails.logger.debug(course.id)
      # returns status of training for a specific course
      result = check_enrollment_and_validity(course, user)
      Rails.logger.debug(result)
      # expired training
      email_content << "Course #{course.course_id}: #{course.name}<br>" if result == 'Expired!'
      # enrollment not found
      null_content << "Course #{course.course_id}: #{course.name}<br>" if result == 'No enrollment'
      # enrollment expiring soon
      if result == 'Expiring Soon!'
        date = TrainingEnrollment.find_by(course_id: course.course_id, user_id: Integer(user.uid, 10)).completion_status
        warning_content << "Course #{course.course_id}: #{course.name} - #{date.to_date}<br>"
      end
    end
    Rails.logger.debug('ENDING')

    # if our content string has info, an email should be sent
    TrainingNotificationMailer.overdue_notification(user, email_content).deliver_now if email_content.present?
    TrainingNotificationMailer.null_notification(user, null_content).deliver_now if null_content.present?
    if warning_content.present?
      Rails.logger.debug('ALPHA')
      TrainingNotificationMailer.warning_notification(user, warning_content).deliver_now
    end
  end

  # check TrainingEnrollment db for enrollment for a specific course and user
  def self.check_enrollment_and_validity(training_course, user)
    enrollment = TrainingEnrollment.find_by(course_id: training_course.course_id, user_id: Integer(user.uid, 10))

    # if it exists
    if enrollment
      check_validity(enrollment)

    else
      # if no enrollment found
      'No enrollment'
    end
  end

  # check if enrollment is valid, expired, or expiring soon (assumes enrollment exists)
  def self.check_validity(enrollment)
    if out_of_date?(enrollment)
      'Expired!'
    elsif almost_out_of_date?(enrollment)
      'Expiring Soon!'
    else
      'Valid'
    end
  end

  # out of date = over 1 year ago
  def self.out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 12.months.ago
  end

  # almost out of date = expires in 1 month
  def self.almost_out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 51.weeks.ago
  end
end
