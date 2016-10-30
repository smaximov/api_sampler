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

  # Set the duration during which collected samples should be stored.
  #
  # Samples are stored indefinetely by default.
  #
  # Store collected samples for one day:
  #     config.samples_expire_in 1.day

  # Set maxumum number of samples collected per time interval.
  #
  # Collect at most 100 samples per day:
  #     config.samples_quota count: 100, per: 1.day

  # Tag matched requests with the specified labels.
  #
  # Tag slow requests with the tag 'slow':
  #     config.tag_with(:slow) { |request| request.time > 200 }
  #
  # Assigning colors to tags
  #     config.tag_with(:deprecated, %r{^/api/v1/.*}, color: 'red')

  # List of keys to exclude from the path parameters of the request.
  # Following parameters are excluded by default:
  #     <%= ApiSampler::Configuration::PATH_PARAMS_BLACKLIST %>
  #
  # Exclude :id from path parameters:
  #     config.path_params_blacklist = %i(id)
  #
  # Don't exclude any parameters from path parameters:
  #     config.path_params_blacklist = nil
end
