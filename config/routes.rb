require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobmonitor'
  
  devise_for :users

  root 'static_pages#home'
  
  get '/help',                                to: 'static_pages#help'
  get '/contact',                             to: 'static_pages#contact'

  get '/ethereum_network',                    to: 'static_pages#ethereum_network'
  get '/binance_exchange',                    to: 'static_pages#binance_exchange'
  get '/binance_smart_chain',                 to: 'static_pages#binance_smart_chain'

  resources :users
end
