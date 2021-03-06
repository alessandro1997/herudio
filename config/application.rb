require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Herudio
  class Application < Rails::Application
    # Generators configuration.
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false

      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = ENV['TIME_ZONE']

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = ENV['LOCALE']
    config.i18n.available_locales = [:it, :en]

    # ActionMailer configuration.
    config.action_mailer.default_url_options = { host: ENV['HOST'] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true

    config.active_job.queue_adapter = :sidekiq

    config.active_record.raise_in_transactional_callbacks = true

    # Dump the schema in SQL rather than Ruby.
    config.active_record.schema_format = :sql

    # Mailer configuration.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
      user_name: ENV.fetch('SENDGRID_USERNAME'),
      password: ENV.fetch('SENDGRID_PASSWORD'),
      domain: ENV.fetch('SENDGRID_DOMAIN'),
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }

    config.assets.paths << Rails.root.join("vendor", "assets", "third-party")
  end
end
