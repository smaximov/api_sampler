# frozen_string_literal: true

require 'api_sampler/middleware'

module ApiSampler
  # Integration with the parent Rails app.
  #
  # ## Usage
  #
  # Add the following line to `config/routes.rb`:
  #
  #     mount ApiSampler::Engine, at: '/api_sampler', as: :api_sampler
  class Engine < ::Rails::Engine
    isolate_namespace ApiSampler

    initializer 'app_sampler.add_middleware' do |app|
      app.middleware.use Middleware
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end
  end
end
