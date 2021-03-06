# frozen_string_literal: true

require 'api_sampler/middleware'

module ApiSampler
  # Integration with the parent Rails app.
  #
  # ## Usage
  #
  # Add the following line to `config/routes.rb` to mount the engine:
  #
  # ``` ruby
  # mount ApiSampler::Engine, at: '/api_sampler'
  # ```
  class Engine < ::Rails::Engine
    isolate_namespace ApiSampler

    initializer 'api_sampler.add_middleware' do |app|
      app.middleware.use Middleware
    end

    initializer 'api_sampler.assets.precompile' do |app|
      app.config.assets.precompile << %w(
        api_sampler/endpoints.js api_sampler/samples.js
      )
      app.config.assets.precompile <<
        %r{semantic-ui/themes/.*\.(?:eot|svg|ttf|woff|woff2|png|gif)$}
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
