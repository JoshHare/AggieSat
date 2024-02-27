# config/schedule.rb
every 3.days, at: '0:00 am' do
  runner "TrainingService.send_emails_for_overdue_trainings"
end
