Rails.application.routes.draw do

  devise_for :users,skip:[:passwords],controllers:{
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_for :admins,skip:[:registrations,:passwords],controllers:{
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    resources :users, only:[:index,:show,:edit,:update] do
      resource :relationships, only:[:create,:destroy]
      get "relationships/followings" => "relationships#followings",as:"user_following"
      get "relationships/followers" => "relationships#followers",as:"user_follower"
    end
    get "users/unsubscribe" => "users#unsubscribe",as:"users_unsubscribe"
    patch "users/withdraw" => "users#withdraw",as:"users_withdraw"
    resources :groups, only:[:new,:create,:index,:show,:destroy]
    get "groups/:id/join" => "groups#join",as:"group_join"
    delete "groups/:id/leave" => "groups#leave",as:"group_leave"
    resources :group_messages, only:[:show,:create,:destroy]
    resources :posts, only:[:new,:create,:index,:show,:destroy] do
      resources :post_comments, only:[:create,:destroy]
      resource :post_favorites, only:[:create,:destroy]
    end
    resources :artists, only:[:index,:show] do
      resource :artist_favorites, only:[:create,:destroy]
    end
    resources :music_favorites, only:[:create,:destroy]
    get "searches" => "searches/search",as:"search"
  end

  namespace :admin do
    get "/" => "homes#top"
    resources :users, only:[:index,:show,:update]
    resources :posts, only:[:index,:destroy]
    resources :post_comments, only:[:index, :update]
    resources :genres, only:[:new, :index,:create,:edit,:update,:destroy]
    resources :inappropriate_comments, only:[:new, :create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
