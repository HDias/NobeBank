Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  namespace :bank do
    resources :accounts,    only: %i[create destroy]
    resources :dashboards,  only: %i[index]
    resources :deposits,    only: %i[new create]
    resources :transfers,   only: %i[new create]
    resources :statements,  only: %i[index]
    resources :withdrawals, only: %i[new create]
  end


  # Defines the root path route ("/")
end
