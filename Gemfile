source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.2.2.1"
gem "image_processing", "~> 1.14.0"
gem "mini_magick", "~> 5.2.0"
gem "active_storage_validations", "~> 3.0.0"
gem "bcrypt", "~> 3.1.20"
gem "faker", "~> 3.5.2"
gem "will_paginate", "~> 3.3.0"
gem "bootstrap-will_paginate", "~> 1.0.0"
gem "bootstrap-sass", "~> 3.4.1"
gem "puma", "~> 6.6.0"
gem "sass-rails", "~> 6.0.0"
gem "turbolinks", "~> 5.2.1"
gem "jbuilder", "~> 2.13.0"
gem "bootsnap", "~> 1.18.6", require: false
gem "jsbundling-rails", "~> 1.3"
gem "matrix", "~> 0.4.3"
gem "mysql2", "~> 0.5.6"
gem "rexml", "~> 3.4"

group :development, :test do
  gem "byebug", "~> 12.0.0", platforms: [:mri, :mingw, :x64_mingw]
  gem "standard", "~> 1.50.0"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "brakeman", "~> 7.0.2"
  gem "cypress-on-rails", "~> 1.17"
end

group :development do
  gem "web-console", "~> 4.2.1"
  gem "rack-mini-profiler", "~> 4.0.0"
  gem "listen", "~> 3.9.0"
  gem "spring", "~> 4.3.0"
end

group :test do
  gem "rspec-rails", "~> 6.1"
  gem "capybara", "~> 3.40.0"
  gem "selenium-webdriver", "~> 3.142.7"
  gem "webdrivers", "~> 4.6.0"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "guard", "~> 2.19.1"
  gem "guard-minitest", "~> 2.4.6"
  gem "simplecov", "~> 0.22.0", require: false
  gem "database_cleaner-active_record", "~> 2.2"
end

group :production do
  gem "aws-sdk-s3", "1.87.0", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Uncomment the following line if you're running Rails
# on a native Windows system:
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
