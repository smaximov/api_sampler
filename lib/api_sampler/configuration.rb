# frozen_string_literal: true

module ApiSampler
  # A class to hold the configuration of **api_sampler**.
  #
  # @example (see #allow)
  class Configuration
    # Allow requests matching the given rule.
    #
    # You can invoke this method multiple times to define a set of rules;
    # a request is allowed as long as it matches any rule from that set.
    #
    # @example Allog requests with query parameter "foo"
    #   ApiSampler.configure do |config|
    #     config.allow do |request|
    #       request.GET.has_key?('foo')
    #     end
    #   end
    #
    # @example Allow POST requests and request to "/api/v1/*" endpoints
    #   ApiSampler.configure do |config|
    #     config.allow %r{^/api/v1/}
    #     config.allow ->(r) { r.post? }
    #   end
    #
    # @return [void]
    # @raise [ArgumentError]
    #   if the rule has invalid type or if both `rule` and the block are
    #   specified, or if none of them are specified.
    #
    # @overload allow(rule)
    #   @param (see ApiSampler::RequestMatcher#initialize)
    # @overload allow
    #   @yield [request]
    #     block which takes the request and returns whether that request
    #     matches.
    #   @yieldparam request [Rack::Request] the current request.
    #   @yieldreturn [Boolean]
    def allow(rule = nil, &block)
      raise ArgumentError, 'either rule or block should be specified' if
        (rule.nil? && block.nil?) || (rule.present? && block.present?)

      request_whitelist << RequestMatcher.new(rule || block)
    end

    # A set of rules to determine allowed requests.
    #
    # @return [Array<RequestMatcher>]
    def request_whitelist
      @request_whitelist ||= []
    end
  end
end
