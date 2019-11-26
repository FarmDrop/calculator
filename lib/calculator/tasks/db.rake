# frozen_string_literal: true
require 'active_support/core_ext/string/inflections'
require 'sequel/core'
require 'shellwords'
require 'faker'
require "pry"

Sequel.extension :migration, :core_extensions

namespace :db do
  desc 'Setup database'
  task :setup do
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['db:test:create'].execute
    Rake::Task['db:test:prepare'].execute
  end

  desc 'Create database'
  task :create do
    if ENV['ENVIRONMENT'] == 'production'
      puts 'rake db:create is disabled in this environment'
      next
    end
    db_url = ENV.fetch('INITIAL_DB_CONNECTION') + ENV.fetch('INITIAL_DB_TABLE')
    Sequel.connect(db_url) do |db|
      db.extension :pg_enum
      db.execute('DROP DATABASE IF EXISTS orders;')
      db.execute('CREATE DATABASE orders;')
    end
    puts 'Db created'
  end

  task :migrate, [:version] do |_t, args|
    version = args[:version].to_i if args[:version]
    Sequel.connect(ENV.fetch('DATABASE_URL')) do |db|
      db.extension :pg_enum
      Sequel::Migrator.run(db, 'db/migrate', target: version)
    end
    Rake::Task['db:structure:dump'].execute
    Rake::Task['db:version'].execute
    puts 'Db migrated'
  end

  desc 'Dump database data into db/dump.sql'
  task :dump do
    database_url = ENV.fetch('DATABASE_URL')
    system(
      %(pg_dump -O #{Shellwords.escape(database_url)}
        --column-inserts
        --data-only > db/dump.sql
      )
    )
  end

  desc 'Import data from db/dump.sql into a development db'
  task :dev_import do
    if %w[staging production].include?(ENV['ENVIRONMENT'])
      puts 'rake db:dev_import is disabled in this environment'
      next
    end

    db_host = ENV.fetch('DB_HOST', 'db')
    system(
      %(PGPASSWORD=secret psql
        -U postgres
        -W postgres
        -h #{Shellwords.escape(db_host)} < db/dump.sql
      )
    )
  end

  namespace :structure do
    desc 'Dump database structure to db/structure.sql'
    task :dump do
      database_url = ENV.fetch('DATABASE_URL')
      if system('which pg_dump', out: File::NULL)
        system(
          %(pg_dump -s -x -O #{database_url} > db/structure.sql)
        )
      end
    end
  end

  desc 'Prints current schema version'
  task :version do
    Sequel.connect(ENV['DATABASE_URL']) do |db|
      version = if db.tables.include?(:schema_migrations)
                  db[:schema_migrations].order(:filename).last[:filename]
                else
                  'not available'
                end

      puts "Schema Version: #{version}"
    end
  end

  desc 'Seed database'
  task :seed do
    require 'calculator'

    20.times do
      delivery_slot_id = Faker::Number.number(digits: 5)
      Calculator::Repositories::DeliverySlot.new.upsert(
        id: delivery_slot_id, state: %w[open closed full closing].sample
      )

      Calculator::Repositories::DeliveryCost.new.upsert(
        id: Faker::Number.number(digits: 5),
        delivery_slot_id: delivery_slot_id,
        cost_pence: Faker::Number.number(digits: 3),
        minimum_spend_pence: Faker::Number.number(digits: 3),
        label: Faker::Movie.quote
      )
    end
    puts 'Db seeded'
  end

  namespace :generate do
    desc 'Generate a migration'
    task :migration do
      name = ARGV[1] || raise(
        ArgumentError, <<~TEXT
          Name missing
          Usage: rake db:generate:migration <name>

        TEXT
      )
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      file_name = name.titleize.gsub(' ', '').underscore
      path = "db/migrate/#{timestamp}_#{file_name}.rb"

      # Fill out the boiler plate
      File.open(path, 'w') do |file|
        file.write <<~CLASS
          Sequel.migration do
            change do
              # do something
            end
          end
        CLASS
      end
      puts "Migration created @ #{path}"
      abort # required
    end
  end

  namespace :test do
    desc 'Create test database'
    task :create do
      Sequel.connect(ENV['DATABASE_URL']) do |db|
        db.execute('DROP DATABASE IF EXISTS orders_test;')
        db.execute('CREATE DATABASE orders_test;')
      end
      puts 'Test db created'
    end

    desc 'Prepare test database for use'
    task :prepare do
      db_url = ENV.fetch('INITIAL_DB_CONNECTION') + '/orders_test'
      Sequel.connect(db_url) do |db|
        sql = File.read('db/structure.sql')
        db.execute(sql)
      end
      puts 'Test db prepared'
    end
  end
end
