Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  namespace :bank do
    resources :accounts, except: %i[edit update]
  end

  resources :dashboards, only: %i[index]

  # Defines the root path route ("/")
end
