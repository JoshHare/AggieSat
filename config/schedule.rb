# config/schedule.rb
# every 1.day, at: '2:42 pm' do
#   runner "TrainingService.send_emails_for_overdue_trainings"
# end
ENV.each_key do |key|
  env key.to_sym, ENV[key]
end
set :environment, ENV["RAILS_ENV"]
set :bundle_gemfile, "/csce431/aggiesat"

set :output, './log/cron.Log'

job_type :rails_runner, "cd :path && :environment_variable=:environment /usr/local/bin/bundle exec /usr/local/bin/rails runner -e :environment ':task' :output"

every 1.minutes do
  runner "/usr/local/bin/ruby /usr/local/bundle/bin/bundle exec /usr/local/bundle/bin/rails runner -e development 'puts \"Hello World\"'"
end
