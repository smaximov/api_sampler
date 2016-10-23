# frozen_string_literal: true

module ApiSampler
  # This class provides rack-compatible middleware to collect and tag API
  # endpoint samples.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end
  end
end
