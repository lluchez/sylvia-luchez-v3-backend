Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config #.merge(skip: [:confirmations, :registrations])
  ActiveAdmin.routes(self)

  root :to => 'home#index'
  get "/health" => "home#health"

  namespace :api do
    namespace :v1 do
      resources :folders, :only => [:show]
      get 'root_folder' => 'folders#root', :as => 'root_folder'
      resources :projects, :only => [:show]
      get 'texts/:code' => 'configurable_texts#show', :as => 'text'
    end
  end
end
