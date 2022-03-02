require 'rails_helper'

RSpec.describe Api::V1::EmailsController, :type => :controller do
  render_views

  describe "POST #create" do
    let(:valid_params) do
      {
        :name => 'Name',
        :email => 'test@test.com',
        :phone => '5550009999',
        :subject => 'Subject',
        :message => 'Message'
      }
    end

    describe '422 responses' do
      it 'should reject when name is blank' do
        post :create, :params => valid_params.merge(:name => '') # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Name is missing',
          'field' => 'name',
          'value' => ''
        })
      end

      it 'should reject when email is blank' do
        post :create, :params => valid_params.merge(:email => nil) # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Email is missing',
          'field' => 'email',
          'value' => ''
        })
      end

      it 'should reject when email is invalid' do
        post :create, :params => valid_params.merge(:email => 'foo') # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Email is invalid',
          'field' => 'email',
          'value' => 'foo'
        })
      end

      it 'should reject when phone is blank' do
        post :create, :params => valid_params.merge(:phone => '') # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Phone is missing',
          'field' => 'phone',
          'value' => ''
        })
      end

      it 'should reject when phone is invalid' do
        post :create, :params => valid_params.merge(:phone => 'foo') # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Phone is invalid',
          'field' => 'phone',
          'value' => 'foo'
        })
      end

      it 'should reject when subject is blank' do
        post :create, :params => valid_params.merge(:subject => '') # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Subject is missing',
          'field' => 'subject',
          'value' => ''
        })
      end

      it 'should reject when message is blank' do
        post :create, :params => valid_params.except(:message) # , :format => :json
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Message is missing',
          'field' => 'message',
          'value' => nil
        })
      end
    end

    describe '500 responses' do
      it 'should fail and raise a rollbar' do
        expect_any_instance_of(Mail::Message).to receive(:deliver!).and_raise(StandardError, 'Unable to send')
        expect(Rollbar).to receive(:error).with(
          "Unable to deliver email",
          :exception => {
            :message => 'Unable to send',
            :klass => 'StandardError'
          }
        ).once
        post :create, :params => valid_params # , :format => :json
        expect(response.status).to eq(500)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Unable to send the message',
          'reason' => 'Unable to send'
        })
      end
    end

    describe '200 responses' do
      it 'should send the email' do
        expect do
          post :create, :params => valid_params # , :format => :json
          expect(response.status).to eq(200)
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        data = JSON.parse(response.body)
        expect(data).to eq({
          'message' => 'Message was successfully sent!'
        })
        mail = ActionMailer::Base.deliveries.last
        expect(mail.subject).to eq('Subject -- Website Inquiry')
      end
    end
  end
end
