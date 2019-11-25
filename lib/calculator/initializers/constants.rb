# frozen_string_literal: true

require 'sequel'

# Basically a global variable so we don't open too many db connections.
class Constants
  TABLES = %w[
    delivery_costs
    delivery_slots
  ].freeze
  Sequel.extension :migration, :core_extensions

  def self.database_url
    db_host = ENV.fetch('DB_HOST', 'localhost')
    ENV.fetch(
      'DATABASE_URL',
      "postgres://postgres:secret@#{db_host}:5432/postgres"
    )
  end

  DB = Sequel.connect(database_url)
  DB.extension :pg_enum

  def self.db
    DB.freeze
  end

  def self.db_tables
    TABLES
  end
end
