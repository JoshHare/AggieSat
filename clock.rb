# frozen_string_literal: true

require 'clockwork'
require './config/boot'
require './config/environment'

# Load the frequency from an environment variable
frequency = ENV.fetch('EMAIL_FREQUENCY', '1.week')

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(frequency, 'email') do
    TrainingService.send_emails_for_overdue_trainings
    TrainingService.send_training_report
  end
end
