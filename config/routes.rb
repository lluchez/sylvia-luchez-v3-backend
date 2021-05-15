Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config #.merge(skip: [:confirmations, :registrations])
  ActiveAdmin.routes(self)

  root :to => 'home#index'

  namespace :api do
    namespace :v1 do
      get "/test" => "test#index"
    end
  end
end
