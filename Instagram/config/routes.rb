# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'

  resources :users
  resources :posts do
    resources :comments
  end
  resources :likes
  resources :relationships
end
