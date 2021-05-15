class Api::V1::TestController < ApplicationController
  skip_before_action :authenticate_admin_user!

  def index
    render :json => 'ok'
  end
end
