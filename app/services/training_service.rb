# app/services/training_service.rb

class TrainingService

  #collects names of students who are not up to date on their training and sends the CSL an email
  def self.send_training_report
    expired = ""
    User.all.each do |user|
      if generate_training_report(user)
        expired << "#{user.full_name}<br>"
      end
    end

    if expired.present?
      TrainingNotificationMailer.training_report(expired).deliver_now
    else
      TrainingNotificationMailer.training_report("All students up to date").deliver_now
    end
  end

  def self.generate_training_report(user)
    TrainingCourse.all.each do |course|
      result = check_enrollment_and_validity(course, user)
      if result == "Expired" || result == "No enrollment"
        return true
      end
    end
    false
  end


  #itereate through each user and check if an email needs to be sent

  def self.send_emails_for_overdue_trainings
    User.all.each do |user|
      send_email_if_overdue(user)
    end
  end

  #for a user, iterate through each training course and evaluate the type of email that needs to be sent.

  def self.send_email_if_overdue(user)
    email_content = ""
    null_content = ""
    warning_content = ""

    #iterate through each required course from training course database
    TrainingCourse.all.each do |course|
      puts user.email
      puts course.id
      result = check_enrollment_and_validity(course, user) #returns status of training for a specific course
      puts result
      if result == "Expired!" #expired training
        email_content << "Course #{course.course_id}: #{course.name}<br>"
      end
      if result == "No enrollment" #enrollment not found
        null_content << "Course #{course.course_id}: #{course.name}<br>"
      end
      if result == "Expiring Soon!" #enrollment expiring soon
        date = TrainingEnrollment.find_by(course_id: course.course_id, user_id: user.uid.to_i).completion_status
        warning_content << "Course #{course.course_id}: #{course.name} - #{date.to_date}<br>"
      end
    end
    puts "ENDING"

    if email_content.present? #if our content string has info, an email should be sent
      TrainingNotificationMailer.overdue_notification(user, email_content).deliver_now
    end
    if null_content.present?
      TrainingNotificationMailer.null_notification(user, null_content).deliver_now
    end
    if warning_content.present?
      puts "ALPHA"
      TrainingNotificationMailer.warning_notification(user, warning_content).deliver_now
    end
  end

  #check TrainingEnrollment db for enrollment for a specific course and user
  def self.check_enrollment_and_validity(training_course, user)
    enrollment = TrainingEnrollment.find_by(course_id: training_course.course_id, user_id: user.id.to_i)

    if enrollment #if it exists
      result = check_validity(enrollment)
      puts "FOUND"
      result
    else #if no enrollment found

      "No enrollment"
    end
  end

  #check if enrollment is valid, expired, or expiring soon (assumes enrollment exists)
  def self.check_validity(enrollment)
    if out_of_date?(enrollment)
      "Expired!"
    elsif almost_out_of_date?(enrollment)
      "Expiring Soon!"
    else
      "Valid"
    end
  end

  #out of date = over 1 year ago
  def self.out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 12.months.ago
  end

  #almost out of date = expires in 1 month
  def self.almost_out_of_date?(enrollment)
    enrollment.completion_status.present? && enrollment.completion_status < 51.weeks.ago

  end
end
