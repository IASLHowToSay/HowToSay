# frozen_string_literal: true

require 'rake/testtask'

task default: [:print_env]

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
#   sh 'pry -r ./specs/test_load_all'
    sh 'pry'
end

namespace :db do
  require_relative 'lib/init' # load libraries
  require_relative 'config/init' # load config info

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


  task :reset_seeds => [:setup, :load_models] do
    app.DB[:schema_seeds].delete if app.DB.tables.include?(:schema_seeds)
    Howtosay::System.dataset.destroy
    Howtosay::Organization.dataset.destroy
    Howtosay::Question.dataset.destroy
    Howtosay::Detail.dataset.destroy
    Howtosay::Cate.dataset.destroy
    Howtosay::Source.dataset.destroy
  end

  desc 'Seeds the development database'
  task :seed => [:setup, :print_env, :load_models] do
    require 'sequel/extensions/seed'
    Sequel::Seed.setup(:development)
    Sequel.extension :seed
    Sequel::Seeder.apply(app.DB, 'db/seeds')
  end

  desc 'export excel format data'
  task :export_excel => [:setup, :print_env, :load_models] do
    require 'csv'
    CSV.open("export.xls", "wb") do |csv|
      csv.to_io.write "\uFEFF"
      csv << ['user', 'category', 'question', 'answer','detail']
      Howtosay::Account.all.each do |account|
        answers = Howtosay::Answer.where(rewriter_id: account.id).all
        answers.each do |answer|
          question = Howtosay::Question.where(id: answer.question_id).first
          cate = Howtosay::Cate.where(id: question.cate_id).first
          good_details = Howtosay::Gooddetail.where(rewriter_id: account.id).where(question_id: answer.question_id).first
          detail = Howtosay::Detail.where(id: good_details.detail_id).first
          csv << [account.name, cate.name, question.content, answer.content, detail.name]
        end
      end
    end
  end

  desc 'testing'
  task :testing => [:setup, :print_env, :load_models] do
    status = Howtosay::System.first
    if Howtosay::Question.where(rewrite_people: status.rewrite_people).count == Howtosay::Question.count
      Howtosay::Question.all.each do |q|
        q.update(rewrite_people: 0)
      end
    end
  end

end

namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require './lib/secure_db'
    puts "DB_KEY: #{SecureDB.generate_key}"
  end
end
