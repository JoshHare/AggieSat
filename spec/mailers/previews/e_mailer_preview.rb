# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/e_mailer
class EMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/e_mailer/training_expired
  def training_expired
    EMailer.training_expired
  end
end
