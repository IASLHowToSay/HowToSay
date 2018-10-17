source 'https://rubygems.org'
ruby '2.3.1'

# Web API
gem 'roda'
gem 'puma'
gem 'json'

# Communication
gem 'http'

# Configuration
gem 'econfig'
gem 'rake'

# Diagnostic
gem 'pry'

# Security
gem 'rbnacl-libsodium'

# Sendgrid
gem 'sendgrid-ruby'

# Database
gem 'sequel'
gem 'hirb'

group :development, :test do
  gem 'sequel-seed'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end


# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
end

# Development
group :development do
  gem 'rubocop'
end

group :development, :test do
  gem 'rerun'
end