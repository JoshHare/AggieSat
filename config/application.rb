ENV['GOOGLE_OAUTH_CLIENT_ID'] = '751341065999-mkqjafmub4mc0pm0n5o5l7dlaqd45r7q.apps.googleusercontent.com'
ENV['GOOGLE_OAUTH_CLIENT_SECRET'] = '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'

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aggiesat
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Central Time (US & Canada)'

    #mailer
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain:  'gmail.com',
      user_name: 'aggiesat.notifs@gmail.com',
      password: 'mjwfupsooirpkkqw', # Or App password, a new one must be generated each time
      authentication: 'plain',
      enable_starttls_auto: true
    }
    config.action_mailer.raise_delivery_errors = true

    # config.eager_load_paths << Rails.root.join("extras")
  end


end
