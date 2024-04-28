# frozen_string_literal: true

require 'clockwork'
require './config/boot'
require './config/environment'

# Load the frequency from an environment variable
FREQUENCY = ENV.fetch('EMAIL_FREQUENCY', '1.week')

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(FREQUENCY, 'email') do
    unless FREQUENCY.to_s.downcase == 'never'
      TrainingService.send_emails_for_overdue_trainings
      puts "RUNNING"
      TrainingService.send_training_report
    end
  end
end
