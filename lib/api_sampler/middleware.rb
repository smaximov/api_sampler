# frozen_string_literal: true

module ApiSampler
  # This class provides rack-compatible middleware to collect and tag API
  # endpoint samples.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      collect_sample(request, response) if allowed?(request)
      [status, headers, response]
    end

    private

    # Collects a sample of the current request.
    #
    # @param request [Rack::Request] current request.
    # @param response [ActiveDispatch::Response::RackBody] response body.
    def collect_sample(request, response)
      endpoint = ApiSampler::Endpoint.find_or_create_by!(path: request.path)
      endpoint.samples.create!(request_method: request.request_method,
                               query: request.query_string,
                               request_body: request.body.read,
                               response_body: response.body)
    rescue ActiveRecord::RecordInvalid => error
      Rails.logger.error "api_sampler :: collect_sample :: #{error}"
    end

    # Check if the request is allowed.
    #
    # @param request [Rack::Request] the current request.
    # @return [Boolean]
    def allowed?(request)
      return false unless ApiSampler.config.request_whitelist.any? do |matcher|
        matcher.matches?(request)
      end

      ApiSampler.config.request_blacklist.none? do |matcher|
        matcher.matches?(request)
      end
    end
  end
end
