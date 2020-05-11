Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" # if Rails.env.development?

  root 'feeds#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, path: 'users'

  resources :users do
    #FIXME_AB: make use of member
    get 'profile', to: 'profiles#edit'
    patch 'profile', to: 'profiles#attach_avatar'
  end

end
