# frozen_string_literal: true
source 'https://rubygems.org'

# Base
ruby '2.3.3'
gem 'rails', '4.2.7.1'
gem 'sdoc', '~> 0.4.0', group: :doc # TODO: document

# ENV
gem 'dotenv-rails'

# M/W
gem 'elasticsearch-model', '0.1.9'
gem 'elasticsearch-rails', '0.1.9'
gem 'mysql2'
gem 'redis-rails'

# SQL Performance
gem 'activerecord-import', '~> 0.10.0'

# AP
gem 'devise'
gem 'jbuilder', '~> 2.0'

# FILE
gem 'rubyzip'

# View
gem 'data-confirm-modal'
gem 'font-awesome-rails'
gem 'gemoji', '~> 2.1.0'
gem 'kaminari'
gem 'redcarpet'

# Stylesheet
gem 'honoka-rails', '~> 3.3.6.0' # gem 'bootstrap-sass'
gem 'sassc-rails' # gem 'sass-rails', '~> 5.0'

# JavaScript
gem 'bower-rails'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '4.1.1'
gem 'uglifier', '>= 1.3.0'
gem 'vuejs-rails', '1.0.21'

# View Performance
gem 'turbolinks', '~> 2.5.0'

# View Log
gem 'quiet_assets'

# View Locale
gem 'rails-i18n', github: 'svenfuchs/rails-i18n', branch: 'rails-4-x'

group :development do
  # Performance
  gem 'activerecord-cause' # tell caller_location
  gem 'bullet' # validate N+1 query
  gem 'spring' # preload application
  gem 'stackprof' # call-stack profiler

  # Debug
  gem 'better_errors'
  gem 'byebug'
  gem 'web-console', '~> 2.0'

  # Data
  gem 'yaml_db'

  # Mail
  gem 'letter_opener'

  # Static analysis
  gem 'rails_best_practices', require: false
  gem 'rubocop', require: false

  # Security
  gem 'brakeman', require: false

  # Deploy
  gem 'capistrano', '~> 3.7.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end

# Server
group :test, :production do
  gem 'therubyracer', platforms: :ruby
  gem 'unicorn'
end
