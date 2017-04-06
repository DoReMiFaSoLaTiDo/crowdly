Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json }, path: '/' do
    resources :users, only: [:show, :index, :create, :update, :destroy]
    resources :sessions, :only => [:create, :destroy]
    resources :posts, only: [:show, :index, :create, :update, :destroy]
  end

end
