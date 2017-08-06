require 'sidekiq/web'

Rails.application.routes.draw do

  root 'welcome#index'
  get 'welcome/index'
  get 'welcome/about'

  devise_for :users, class_name: 'FormUser',
             :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                               registrations: 'registrations'}

  devise_scope :user do
    get '/users/auth/:provider/upgrade' => 'omniauth_callbacks#upgrade', as: :user_omniauth_upgrade
    get '/users/auth/:provider/setup', :to => 'omniauth_callbacks#setup'
  end


  resources :polls do
    resources :comments
    resources :options
    resources :reports
  end

  resources :comments do
    resources :comments
    resources :reports
    member { post :vote }
  end

  resources :options do
    member { post :vote }
  end

  namespace :admin do
    # get 'dashboard/index'
    get '', to: 'dashboard#index', as: '/'
    resources :polls
    resources :comments
  end

  resources :user do
    resources :polls, only: :index
    resources :comments, only: :index
  end

  # match "feedback" => "feedback_messages#new", :as => "feedback", via: :get
  resources :feedback_messages

  mount Sidekiq::Web, at: "/sidekiq"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
