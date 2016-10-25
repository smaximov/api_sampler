# frozen_string_literal: true

module ApiSampler
  # A class to hold the configuration of **api_sampler**.
  #
  # @example (see #allow)
  # @example (see #deny)
  # @example (see #samples_expire_in)
  class Configuration
    # Allow requests matching the given rule.
    #
    # You can invoke this method multiple times to define a set of rules;
    # a request is considered allowed as long as it matches any rule from
    # that set.
    #
    # @example Allow requests with query parameter "foo"
    #   ApiSampler.configure do |config|
    #     config.allow do |request|
    #       request.GET.key?('foo')
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
    #
    # @note rules defined here may be overriden by the rules defined in
    #   {#deny}.
    def allow(rule = nil, &block)
      raise ArgumentError, 'either rule or block should be specified' if
        (rule.nil? && block.nil?) || (rule.present? && block.present?)

      request_whitelist << RequestMatcher.new(rule || block)
    end

    # Define rules to deny requests previously matched by {#allow} rules.
    #
    # You can invoke this method multiple times to define a set of rules;
    # a request is considered denied as long as it matches any rule from
    # that set.
    #
    # @example Deny POST requests
    #   ApiSampler.configure do |config|
    #     config.deny(&:post?)
    #   end
    #
    # @example Allow all requests to "/api/v1/*" endpoints except PUT requests
    #   ApiSampler.configure do |config|
    #     config.allow %r{^/api/v1/}
    #     config.deny(&:put?)
    #   end
    #
    # @return [void]
    # @raise (see #allow)
    #
    # @overload deny(rule)
    #   @param (see ApiSampler::RequestMatcher#initialize)
    # @overload deny
    #   @yield [request]
    #     block which takes the request and returns whether that request
    #     matches.
    #   @yieldparam request [Rack::Request] the current request.
    #   @yieldreturn [Boolean]
    #
    # @note rules defined here take precedence over the rules defined in
    #   {#allow}.
    def deny(rule = nil, &block)
      raise ArgumentError, 'either rule or block should be specified' if
        (rule.nil? && block.nil?) || (rule.present? && block.present?)

      request_blacklist << RequestMatcher.new(rule || block)
    end

    # @!attribute [r] request_whitelist
    # @return [Array<RequestMatcher>]
    #   the set of rules to determine allowed requests.
    #
    # @note these rules may be overriden by the rules in {#request_blacklist}.
    def request_whitelist
      @request_whitelist ||= []
    end

    # @!attribute [r] request_blacklist
    # @return [Array<RequestMatcher>]
    #   the set of rules to determine denied requests.
    #
    # @note these rules take precedence over the rules in {#request_whitelist}.
    def request_blacklist
      @request_blacklist ||= []
    end

    # Set the duration during which collected samples should be stored.
    #
    # @note Samples are stored indefinetely by default.
    #
    # @example Store collected samples for one day
    #   AppSampler.configure do |config|
    #     config.samples_expire_in 1.day
    #   end
    #
    # @param duration [ActiveSupport::Duration, nil]
    #   the duration specifying the lifetime of collected samples. Passing `nil`
    #   means storing collected samples indefinetely.
    #
    # @return [void]
    #
    # @raise [ArgumentError] if `duration` has invalid type.
    def samples_expire_in(duration)
      raise ArgumentError, 'expected ActiveSupport::Duration or nil' unless
        duration.nil? || duration.is_a?(ActiveSupport::Duration)

      @samples_expiration_duration = duration
    end

    # @return [ActiveSupport::Duration, nil]
    #   the duration during which collected samples should be stored.
    attr_reader :samples_expiration_duration
  end
end
