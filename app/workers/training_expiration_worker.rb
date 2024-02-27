# app/workers/training_expiration_worker.rb
class TrainingExpirationWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    send_email_if_overdue(user)
  end

  private
  #TrainingExpirationMailer.expiration_notification(user.email).deliver_now
  def send_email_if_overdue(user)
    body = ""
    TrainingCourse.all.each do |course|
      result = TrainingService.check_enrollment_and_validity(course,user)
      if result  == "Expired!"
        body << "#{course.id}: Expired"
      elsif result == "Expiring Soon!"
        body << "#{course.id}: Expiring Soon!"
      end
    end
    return body

  end


end
