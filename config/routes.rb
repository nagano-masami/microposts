Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  #中間テーブルから先にある、フォロー中のユーザとフォローされているユーザ一覧を表示するベージ
  #そのためのルーティングが下記
  resources :users, only: [:index, :show, :create] do
    member do
      #:idを持つユーザのフォローユーザ一覧を表示する機能をControllerでつける
      get :followings
      get :followers
    end
    collection do
      get :search
    end
  end

  resources :microposts, only: [:create, :destroy]
  #ログインユーザがユーザをフォロー・アンフォローできるようにするルーティング
  resources :relationships, only: [:create, :destroy]
end
