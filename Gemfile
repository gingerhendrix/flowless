source "https://rubygems.org"

ruby "2.0.0"

gem "rails", "4.0.1"
gem "mongoid", github: "mongoid/mongoid"
gem "sass-rails", "~> 4.0.1"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.1"
gem 'haml-rails', '~> 0.4'
gem "therubyracer", platforms: :ruby
gem "jquery-rails", '3.0.4'
gem "turbolinks"
gem "jbuilder", "~> 1.2"
gem 'foreman',   '~> 0.63.0'
gem 'puma',      '~> 2.6.0'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem "guard-rspec"
  gem "pry"
  gem "quiet_assets"
  gem "pry-rails"
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "erb2haml"
  gem "zeus", '0.13.3'
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'terminal-notifier-guard'
end

group :test do
  gem "mongoid-rspec"
  gem "ffaker"
  gem "database_cleaner"
  gem "codeclimate-test-reporter", require: false
end

#gem 'redcarpet'
gem "kaminari"
gem 'memcachier'
gem 'dalli'
gem "localeapp"
gem "github-markdown", "~> 0.6.3"
gem 'newrelic_rpm'
gem 'darwinjs-rails', "~> 1.2"
gem 'bootstrap-generators', :github => 'decioferreira/bootstrap-generators'
gem "font-awesome-sass-rails"
gem "simple_form", github: "plataformatec/simple_form"
gem "devise", "~> 3.2.1"
gem "cancan", "~> 1.6.10"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"
gem "hashugar", github: "alex-klepa/hashugar"