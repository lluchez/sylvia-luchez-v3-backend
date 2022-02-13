require 'rails_helper'

describe InquiryMailer do
  describe '#new_inquiry_email' do
    it 'should send an email with provided information' do
      message = "<b>some</b><i>safe</i><script>/* text */<script>"
      mail = described_class.with({
        :name => 'Someone',
        :email => 'test@test.com',
        :phone => '5550001234',
        :subject => 'Contact',
        :message => message
      }).new_inquiry_email.deliver!

      expect(mail.from).to eq(['artist@biz.foo'])
      expect(mail.to).to eq(['artist@biz.foo'])
      expect(mail.reply_to).to eq(['test@test.com'])
      expect(mail.subject).to eq('Contact -- Website Inquiry')

      email_body = retrieve_html_body_part(mail)
      expect(email_body).to include('You received an email from Someone who')
      expect(email_body).to include('Name: Someone')
      expect(email_body).to include('Email: test@test.com')
      expect(email_body).to include('Phone: 555-000-1234')
      expect(email_body).to include('Subject: Contact')
      expect(email_body).to include('&lt;b&gt;some&lt;/b&gt;&lt;i&gt;safe&lt;/i&gt;&lt;script&gt;/* text */&lt;script&gt;') # html encoded message
    end
  end
end
