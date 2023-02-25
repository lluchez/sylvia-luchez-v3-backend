source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

gem 'aws-sdk-s3'
gem 'activeadmin'
gem 'activeadmin_quill_editor'
gem 'audited'
gem 'bootsnap', '>= 1.4.4'
gem 'delayed_job_active_record'
gem 'devise'
gem 'image_processing'
gem 'jbuilder', '~> 2.7'
gem 'mysql2', '~> 0.5'
gem 'puma'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails'
gem 'rollbar'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', :platforms => [:mri, :mingw, :x64_mingw]

  # gem 'active_record_query_trace'
  # gem 'selenium-webdriver'
  # gem 'simple_xlsx_reader'
  # gem 'timecop'
end

group :development do
  gem 'annotate'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop-rails', :require => false
  gem 'spring'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '>= 3.26'
  gem 'codecov', :require => false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  # gem 'selenium-webdriver'
  gem 'shoulda'
  # Easy installation and use of web drivers to run system tests with browsers
  # gem 'webdrivers'
end

group :development, :test, :stage do
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => [:mingw, :mswin, :x64_mingw, :jruby]
