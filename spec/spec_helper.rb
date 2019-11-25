# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
ENV['DATABASE_URL'] = "postgres://postgres:secret@#{ENV['DB_HOST']}:5432/orders_test"

require 'bundler/setup'
require 'calculator'

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:each, db: true) do
    Constants.db_tables.each do |table|
      Constants.db.execute("TRUNCATE #{table} CASCADE;")
    end
  end
end
