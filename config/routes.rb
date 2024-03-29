Rails.application.routes.draw do

  devise_for :users,skip:[:passwords],controllers:{
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  devise_for :admins,skip:[:registrations,:passwords],controllers:{
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    resources :users, only:[:index, :show, :edit, :update] do
      resources :reports, only:[:new, :create]
      resource :relationships, only:[:create, :destroy]
      get "relationships/followings" => "relationships#followings",as:"user_following"
      get "relationships/followers" => "relationships#followers",as:"user_follower"
    end
    resources :groups, only:[:new, :create, :index, :show, :destroy, :edit, :update]
      get "groups/:id/join" => "groups#join",as:"group_join"
      delete "groups/:id/leave" => "groups#leave",as:"group_leave"
    resources :group_messages, only:[:show, :create, :destroy]
    resources :posts, only:[:new, :create, :index, :show, :destroy, :edit, :update] do
      resources :post_comments, only:[:create, :destroy]
      resource :post_favorites, only:[:create, :destroy]
    end
    resources :artists, only:[:index, :show] do
      resource :artist_favorites, only:[:create, :destroy]
    end
    resources :music_favorites, only:[:create, :destroy]
    resources :notifications, only:[:update]
  end

  namespace :admin do
    get "/" => "homes#top"
    resources :users, only:[:index, :show, :update]
    resources :posts, only:[:index, :destroy]
    resources :post_comments, only:[:index, :update]
    resources :genres, only:[:new, :index, :create, :edit, :update, :destroy]
    resources :inappropriate_comments, only:[:new, :create, :destroy]
    resources :reports, only:[:index, :show, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
