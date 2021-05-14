Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config #.merge(skip: [:confirmations, :registrations])
  ActiveAdmin.routes(self)

  root :to => 'home#index'
end
