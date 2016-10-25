# frozen_string_literal: true

# api_sampler configuration.
ApiSampler.configure do |config|
  # Allow requests matching the given rule.
  #
  # By default no requests are allowed.
  #
  # Allow requests with query parameter "foo":
  #     config.allow do |request|
  #       request.GET.key?('foo')
  #     end
  #
  # Allow POST requests and request to "/api/v1/*" endpoints:
  #     config.allow %r{^/api/v1/}
  #     config.allow ->(r) { r.post? }
  #
  # Allow all requests:
  #     config.allow(/.*/)
  config.allow(/.*/)            # allow all requests

  # Define rules to deny requests previously matched by `allow` rules.
  #
  # Deny POST requests:
  #   ApiSampler.configure do |config|
  #     config.deny(&:post?)
  #   end
  #
  # Allow all requests to "/api/v1/*" endpoints except PUT requests:
  #     config.allow %r{^/api/v1/}
  #     config.deny(&:put?)
end
