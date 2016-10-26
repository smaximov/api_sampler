# frozen_string_literal: true
ApiSampler::Engine.routes.draw do
  root to: 'endpoints#index'
  resources :endpoints, only: %(index)
end
