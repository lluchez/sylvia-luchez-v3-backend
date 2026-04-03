require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  include Devise::Test::ControllerHelpers

  render_views

  describe "GET #index" do
    context "with a logged out user" do
      it "should return a 302 response" do
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end
    context "with a logged in user" do
      let(:user) { FactoryBot.create(:admin_user) }

      before do
        allow(controller).to receive(:current_admin_user).and_return(user)
      end

      it "should return a 302 response" do
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe "GET #health" do
    it "should return a 200 response" do
      get :health, :format => :json
      expect(response.status).to eq(200)

      data = JSON.parse(response.body)
      expect(data['ok']).to eq(true)
    end
  end
end
