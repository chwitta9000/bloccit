Bloccit::Application.routes.draw do

  devise_for :users

  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create]
    end
  end

  match "newest" => 'posts#newest', via: :get

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end
