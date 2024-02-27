# app/services/training_service.rb

class TrainingService
  def self.send_emails_for_overdue_trainings
    User.all.each do |user|
      send_email_if_overdue(user)
    end
  end

  def self.send_email_if_overdue(user)
    email_content = ""
    null_content = ""
    warning_content = ""

    TrainingCourse.all.each do |course|
      puts user.email
      puts course.id
      result = check_enrollment_and_validity(course, user)
      puts result
      if result == "Expired!"
        email_content << "Course #{course.id}: #{course.name}\n"
      end
      if result == "No enrollment"
        null_content << "Course #{course.id}: #{course.name}\n"
      end
      if result == "Expiring Soon!"
        warning_content << "Course #{course.id}: #{course.name} expiring soon\n"
      end
    end
    puts "ENDING"

    if email_content.present?
      TrainingNotificationMailer.overdue_notification(user, email_content).deliver_now
    end
    if null_content.present?
      TrainingNotificationMailer.null_notification(user, null_content).deliver_now
    end
    if warning_content.present?
      TrainingNotificationMailer.warning_notification(user, warning_content).deliver_now
    end
  end


  def self.check_enrollment_and_validity(training_course, user)
    enrollment = TrainingEnrollment.find_by(course_id: training_course.id, user_id: user.id)

    if enrollment
      result = check_validity(enrollment)
      result
    else
      "No enrollment"
    end
  end

  def self.check_validity(enrollment)
    if out_of_date?(enrollment)
      "Expired!"
    elsif almost_out_of_date?(enrollment)
      "Expiring Soon!"
    else
      "Valid"
    end
  end

  def self.out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 12.months.ago
  end

  def self.almost_out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 11.months.ago
  end
end
