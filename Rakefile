# frozen_string_literal: true

require 'rake/testtask'

# task default: [:spec]

# desc 'Tests API specs only'
# task :api_spec do
#   sh 'ruby specs/api_spec.rb'
# end

# desc 'Run all the tests'
# Rake::TestTask.new(:spec) do |t|
#   t.pattern = 'specs/*_spec.rb'
#   t.warning = false
# end

# desc 'Runs rubocop on tested code'
# task style: [:spec] do
#   sh 'rubocop app.rb models/*.rb'
# end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
#   sh 'pry -r ./specs/test_load_all'
end

namespace :db do
  require_relative 'lib/init' # load libraries
  require_relative 'config/init' # load config info
  app = Howtosay::Api

  Sequel.extension :migration
  app = Howtosay::Api

  task :setup do
    require 'sequel'
    Sequel.extension :migration
  end

  task :load_models do
    require_relative 'models/init'
    require_relative 'services/init'
  end

  desc 'Run migrations'
  task :migrate => [:setup, :print_env] do
    puts 'Migrating database to latest'
    Sequel::Migrator.run(app.DB, 'db/migrations')
  end


  desc 'Delete dev or test database file'
  task :drop do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end
    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end


  desc 'Delete and migrate again'
  task reset: [:drop, :migrate]
end

namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require './lib/secure_db'
    puts "DB_KEY: #{SecureDB.generate_key}"
  end
end
