require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module InternalRailsProject
  class Application < Rails::Application
    config.load_defaults 6.0
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.action_mailer.default_url_options = { host: ENV['host'], port: ENV['port'] }
  end
end
