# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'aggiesat.notifs@gmail.com'
  layout 'mailer'
end
