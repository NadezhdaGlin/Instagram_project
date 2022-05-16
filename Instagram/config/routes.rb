Rails.application.routes.draw do
  devise_for :users
  root "posts#index"

  resources :users
  resources :posts do
    resources :comments
  end
  resources :likes
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy]

end
