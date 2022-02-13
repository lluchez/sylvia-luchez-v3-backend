class ApplicationMailer < ActionMailer::Base
  default :from => DynamicConfig.mailers['artist']
  layout 'mailer'
end
