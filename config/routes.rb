Rails.application.routes.draw do
  devise_for :users

  namespace :bank do
    resources :accounts, except: %i[edit update]
    resources :dashboards, only: %i[index]
  end

  # Defines the root path route ("/")
end
