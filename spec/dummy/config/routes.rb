Rails.application.routes.draw do
  mount ApiSampler::Engine => "/api_sampler"
end
