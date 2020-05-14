Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  root 'feeds#index'

  devise_for :users, path: 'users'

  resources :users do
    member do
      get 'profile', to: 'profiles#edit'
      patch 'profile', to: 'profiles#update'
    end
  end

end
