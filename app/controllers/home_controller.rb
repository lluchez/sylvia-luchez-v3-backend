class HomeController < ApplicationController
  def index
    if current_admin_user.present?
      redirect_to(admin_root_path)
    else
      redirect_to(admin_user_session_path)
    end
  end
end
