# frozen_string_literal: true

module ApiSampler
  # Match requests according to the specified rule.
  #
  # @example Regexp rule
  #   rule = %r{^/api/v1}
  #   matcher = ApiSampler::RequestMatcher.new(rule)
  #   request = Rack::Request.new(Rack::MockRequest.env_for('http://example.com/api/v1/kittens'))
  #   matcher.matches?(request) #=> true
  #
  # @example Callable rule
  #   rule = ->(r) { r.request_method == 'PUT' }
  #   matcher = ApiSampler::RequestMatcher.new(rule)
  #   request = Rack::Request.new(Rack::MockRequest.env_for('http://example.com/api/v1/kittens',
  #                                                         method: 'PUT'))
  #   matcher.matches?(request) #=> true
  class RequestMatcher
    # @param rule [Regexp, #call]
    #   the rule determining whether the particular request should match.
    #
    #   If `rule` is Regexp, match is determined by testing the regexp
    #   against the request path. If `rule` responds to `#call`, it is
    #   invoked with the current request as the argument; the request
    #   is considered matched if `#call` returns a truthy value.
    # @raise [ArgumentError] if `rule` has invalid type.
    def initialize(rule)
      @rule = validate_and_normalize_rule(rule)
    end

    # Return true if the request matches, false otherwise.
    #
    # @param request [Rack::Request] the current request.
    # @return [Boolean] whether the request matches.
    def matches?(request)
      !!@rule.call(request)     # rubocop:disable Style/DoubleNegation
    end

    private

    def validate_and_normalize_rule(rule)
      if rule.is_a?(Regexp)
        ->(request) { rule =~ request.path }
      elsif rule.respond_to?(:call)
        rule
      else
        raise ArgumentError, 'expected a callable or an instance of Regexp'
      end
    end
  end
end
