Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  root 'feeds#index'

  devise_for :users, path: 'users'

  resources :users do
    resource :profile, only: [:edit, :update, :show]
  end

  resources :questions, param: :slug do
    collection do
      get :drafts
    end

    member do
      post :upvote, to: "votes#upvote"
      
      post :downvote, to: "votes#downvote"
    end
  end

  resources :notifications, only: [:index, :destroy] do
    member do
      get :markseen
    end
  end
end
