# frozen_string_literal: true
ApiSampler::Engine.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root to: 'endpoints#index'
  resources :endpoints, only: %i(index), concerns: :paginatable
end
