Rails.application.routes.draw do
  root 'feeds#index'
  devise_for :users
end
