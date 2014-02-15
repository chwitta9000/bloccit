Bloccit::Application.routes.draw do

  get "posts/index"

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}

  resources :users, only: [:show, :index]

  resources :posts, only: [:index]

  resources :topics do
    resources :posts, except: [:index], controller: 'topics/posts' do
      resources :comments, only: [:create, :destroy]
      match '/up_vote', to: 'votes#up_vote', as: :up_vote
      match '/down_vote', to: 'votes#down_vote', as: :down_vote
      resources :favorites, only: [:create, :destroy]
    end
  end

  match "newest" => 'posts#newest', via: :get

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end
