require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key                = ENV['LOCALE_APP_KEY'] || 'no_key_to_avoid_exception'
  config.polling_environments   = [ :production ]
  config.poll_interval          = 60
  config.reloading_environments = [:development, :production]
  config.sending_environments =   [ ]
end

if defined?(Rails) && Rails.env.production?
  Localeapp::CLI::Pull.new.execute
end