require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key                = 'ecJz7d5rHZ1fhDFFyKOUeefJdQcjleNmZiXLOPHyEhpkwDPy2p'
  config.polling_environments   = [ :production ]
  config.poll_interval          = 60
  config.reloading_environments = [:development, :production]
  config.sending_environments =   [ ]
end

if defined?(Rails) && Rails.env.production?
  Localeapp::CLI::Pull.new.execute
end