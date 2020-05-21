Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  root 'feeds#index'

  devise_for :users, path: 'users'

  resources :users do
    resource :profile, only: [:edit, :update]
  end

end
