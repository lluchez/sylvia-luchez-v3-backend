ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SMTP_USERNAME'].presence || 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  :password => ENV['SMTP_PASSWORD'].presence || ENV['SENDGRID_API_KEY'], # This is the secret sendgrid API key which was issued during API key creation
  :domain => ENV['SMTP_USERNAME'].try(:split, '@').try(:last) || ENV['SMTP_DOMAIN'].presence || 'sylvialuchez.com',
  :address => ENV['SMTP_ADDRESS'].presence || 'smtp.sendgrid.net',
  :port => ENV['SMTP_PORT'].present? ? ENV['SMTP_PORT'].to_i : 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
