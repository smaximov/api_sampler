Rails.application.routes.draw do
  mount ApiSampler::Engine, at: '/api_sampler'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/kthnxbye', to: 'basic#kthnxbye'
      get '/echo_get', to: 'basic#echo_get'
    end
  end
end
