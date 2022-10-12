Rails.application.routes.draw do
  devise_for :users

  namespace :bank do
    resources :accounts, except: %i[edit update]
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
