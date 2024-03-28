# app/mailers/training_notification_mailer.rb
class TrainingNotificationMailer < ApplicationMailer

  def training_report(content)
    Rails.logger.debug("Executing training_report method")
    @content = content
    admin_emails = User.where(role: 'Admin').pluck(:email)
    puts admin_emails
    puts content
    mail(
      to: "jmhhare@gmail.com",
      subject: 'AggieSat: Training Report',
      from: "aggiesat.notifs@gmail.com"
      )
  end


  def overdue_notification(user, content)
    @user = user
    @content = content
    mail(
      to: user.email,
      subject: 'AggieSat: Expired Training',
      from: "aggiesat.notifs@gmail.com"
      )
  end

  def null_notification(user, content)
    @user = user
    @content = content

    mail(
      to: user.email,
      subject: 'AggieSat: No Training Notification',
      from: "aggiesat.notifs@gmail.com"
      )
  end

  def warning_notification(user, content)
    @user = user
    @content = content
    mail(
      to: user.email,
      subject: 'AggieSat: Training Expiring Soon',
      from: "aggiesat.notifs@gmail.com"
      )
  end
end
