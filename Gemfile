# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.3'

gem 'agoo'
gem 'pry' # used in prod for better console
gem 'rake'
gem 'thor'

# Database

gem 'pg'
gem 'sequel'

group :development, :test do
  gem 'bundler-audit'
  gem 'dotenv'
  gem 'faker'
  gem 'pry-byebug'
end

group :test do
  gem 'factory_bot', '~> 5.0', '>= 5.0.2'
  gem 'rspec'
  gem 'vcr'
  gem 'webmock'
end
