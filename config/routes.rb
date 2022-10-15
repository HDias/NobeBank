Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  namespace :bank do
    resources :accounts, except: %i[edit update]
    resources :dashboards, only: %i[index]
  end


  # Defines the root path route ("/")
end
