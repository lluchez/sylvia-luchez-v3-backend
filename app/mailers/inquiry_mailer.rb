class InquiryMailer < ApplicationMailer
  def new_inquiry_email
    @params = params # for templates
    email, subject = params.values_at(:email, :subject)

    mail(
      :to => DynamicConfig.mailers['artist'],
      :reply_to => email,
      :subject => "#{subject} -- Website Inquiry"
    )
  end
end
