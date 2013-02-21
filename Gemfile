source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'travian', git: "https://travnoty:136d61d3c9624a770ba085e559839d6f83b22cb3@github.com/jasoares/travian.git", tag: 'v0.7.4'
gem 'rspec-rails', '~> 2.0', group: [:development, :test]
gem 'timecop', group: [:development, :test]
gem 'yaml_db', group: [:development, :test]

group :development do
  gem 'guard'
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer', :platforms => :ruby
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'fakeweb'
  gem 'capybara'
  gem 'simplecov', :require => false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
