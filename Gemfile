source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails',            '~> 4.1'   # rails
gem 'mongoid',          '~> 4.0'   # mongoid
gem 'sass-rails',       '~> 4.0'   # brings sass support
gem 'coffee-rails',     '~> 4.0'   # brings coffee support
gem 'jquery-rails',     '~> 3.1'   # brings jQuery support
#gem 'jquery-ui-rails',  '~> 5.0'   # adding the jquery UI features
gem 'haml-rails',       '~> 0.5'   # brings Haml support
gem 'bootstrap-sass',   '~> 3.2'   # adds the bootstrap framework
gem 'uglifier',         '~> 2.5'   # compressed and uglify JS
gem 'darwinjs-rails',   '~> 1.2'   # MV object framework on top of jQuery
gem 'puma',             '~> 2.8'   # webserver
gem 'recurrence',       '~> 1.3'   # handles recurrence to manage events
gem 'kaminari',         '~> 0.16'  # handles pagination
gem 'memcachier',       '~> 0.0.2' # handles the caching process
gem 'dalli',            '~> 2.7'   # works with memcachier to handle caching
gem 'localeapp',        '~> 0.8'   # I18n translation backend
gem 'github-markdown',  '~> 0.6'   # Interprets github markdown
gem 'newrelic_rpm',     '~> 3.9'   # monitoring on newrelic
gem 'simple_form',      '~> 3.1.0.rc1' # helps creates form easier
gem 'cocoon',           '~> 1.2'   # allow for dynamic management of form with nested documents
gem 'devise',           '~> 3.2'   # authentication handling
gem 'cancan',           '~> 1.6'   # access right management
gem 'hashugar',         '~> 0.0.6' # allows for nice access to hashes
gem 'jquery-turbolinks','~> 2.0'   # for the ability to use jquery load with turbolinks
gem 'turbolinks',       '~> 2.2'   # allows not to realod the entire page with CSS and JS
gem 'base_presenter',   '~> 0.1.0' # adding presenter abilities

gem 'bootstrap-select-rails', '~> 1.3' # adds the assets for bootstrap-select

gem 'omniauth',         '~> 1.2'   # handles omniauth authentication
gem 'omniauth-facebook','~> 1.6'   # works with omniauth to authenticate with facebook
gem 'omniauth-twitter', '~> 1.0'   # works with omniauth to authenticate with twitter

# gem 'redcarpet'
# gem 'therubyracer', platforms: :ruby  # allow ruby to interpret JS
# gem 'jbuilder'                        # builds json
# gem 'font-awesome-sass-rails          # helps use many fonts on the app


gem 'coveralls', require: false  # provides test coverage data

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'guard-rspec'
  gem 'quiet_assets'
end

group :test do
  gem 'mongoid-rspec'
  gem 'ffaker'
  gem 'simplecov', require: false
  gem 'database_cleaner'
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  #gem 'pry-debugger'
  gem 'pry-stack_explorer'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'erb2haml'
  gem 'zeus'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails'
  gem 'terminal-notifier-guard'
end
