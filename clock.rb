# clock.rb
# clock.rb
require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.week, 'email') do
    TrainingService.send_emails_for_overdue_trainings
    TrainingService.send_training_report

  end
end
