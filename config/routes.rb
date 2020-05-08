Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" # if Rails.env.development?
  
  root 'feeds#index'
  devise_for :users
end
