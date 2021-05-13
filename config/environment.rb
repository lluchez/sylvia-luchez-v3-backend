# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SMTP_USERNAME'].presence || 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  :password => ENV['SMTP_PASSWORD'].presence || ENV['SENDGRID_API_KEY'], # This is the secret sendgrid API key which was issued during API key creation
  # :domain => 'sylvialuchez.com',
  :address => ENV['SMTP_ADDRESS'].presence || 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
