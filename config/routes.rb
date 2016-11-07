# frozen_string_literal: true
ApiSampler::Engine.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root to: 'endpoints#index'
  resources :endpoints, only: %i(index), concerns: :paginatable,
                        shallow: true do
    resources :samples, only: %i(index), concerns: :paginatable do
      collection do
        delete :delete
      end

      member do
        get :request_body
        get :response_body, action: :response_body_
      end
    end
  end
end
