class Api::V1::EmailsController < Api::V1::BaseController
  def create
    validated_email_params!
    mailer = InquiryMailer.with(email_params)
    begin
      mailer.new_inquiry_email.deliver!
      render_email_sent_response
    rescue StandardError => e
      email_failure_rollbar(e)
      render_sending_email_error_response(e)
    end
  end

  protected

  def render_email_sent_response
    render :json => { :message => 'Message was successfully sent!' }, :status => :ok
  end

  def render_sending_email_error_response(exception)
    render :json => {
      :message => 'Unable to send the message',
      :reason => exception.message
    }, :status => :internal_server_error
  end

  def email_failure_rollbar(exception)
    Rollbar.error(
      "Unable to deliver email",
      :exception => {
        :message => exception.message,
        :klass => exception.class.to_s
      }
    )
  end

  def validated_email_params!
    name, email, phone, subject, message = email_params.values_at(:name, :email, :phone, :subject, :message)

    name.present? or raise Exceptions::ValidationException.new('Name is missing', :name, name)
    email.present? or raise Exceptions::ValidationException.new('Email is missing', :email, email)
    email.match?(URI::MailTo::EMAIL_REGEXP) or raise Exceptions::ValidationException.new('Email is invalid', :email, email)
    phone.present? or raise Exceptions::ValidationException.new('Phone is missing', :phone, phone)
    phone.match?(/\A\+?\d{10,}\z/) or raise Exceptions::ValidationException.new('Phone is invalid', :phone, phone)
    subject.present? or raise Exceptions::ValidationException.new('Subject is missing', :subject, subject)
    message.present? or raise Exceptions::ValidationException.new('Message is missing', :message, message)
  end

  def email_params
    @email_params ||= params.permit(:name, :email, :phone, :subject, :message)
  end
end
