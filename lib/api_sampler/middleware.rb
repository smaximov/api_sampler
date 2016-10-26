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
      delete_expired_samples

      endpoint = ApiSampler::Endpoint.find_or_create_by!(path: request.path)
      sample = endpoint.samples.create!(request_method: request.request_method,
                                        query: request.query_string,
                                        request_body: request.body.read,
                                        response_body: response.body)
      tag(sample, request)
    rescue ActiveRecord::RecordInvalid => error
      Rails.logger.error "api_sampler :: collect_sample :: #{error}"
    end

    # Check if the request's sample is to be stored.
    #
    # @param request [Rack::Request] the current request.
    # @return [Boolean]
    def allowed?(request)
      whitelisted?(request) && !blacklisted?(request) && meets_quota?
    end

    def whitelisted?(request)
      ApiSampler.config.request_whitelist.any? do |matcher|
        matcher.matches?(request)
      end
    end

    def blacklisted?(request)
      ApiSampler.config.request_blacklist.any? do |matcher|
        matcher.matches?(request)
      end
    end

    def meets_quota?
      return true if ApiSampler.config.samples_quota_count.nil?

      ApiSampler::Sample
        .where('created_at >= ?', ApiSampler.config.samples_quota_duration.ago)
        .count < ApiSampler.config.samples_quota_count
    end

    # Delete samples older than {Configuration#samples_expiration_duration}.
    #
    # @return [void]
    def delete_expired_samples
      return if ApiSampler.config.samples_expiration_duration.nil?

      expiration_bound = ApiSampler.config.samples_expiration_duration.ago
      ApiSampler::Sample.where('created_at < ?', expiration_bound).destroy_all
    end

    # Tag the sample according to the rules in {Configuration#request_tags}.
    #
    # @param sample [ApiSampler::Sample]
    # @param request [Rack::Request]
    #
    # @return [void]
    #
    # @raise [ActiveRecord::RecordInvalid]
    def tag(sample, request)
      tags = ApiSampler.config.request_tags.each_with_object(Set.new) do |t, s|
        s << t.name if t.matcher.matches?(request)
      end

      tags.each do |tag|
        sample.tags << ApiSampler::Tag.find_or_create_by!(name: tag)
      end
    end
  end
end
