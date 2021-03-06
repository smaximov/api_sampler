# frozen_string_literal: true

module ApiSampler
  # A class to hold the configuration of **api_sampler**.
  class Configuration
    # Default keys to exclude from the path parameters of the
    # request.
    PATH_PARAMS_BLACKLIST = [:action, :controller].freeze # rubocop:disable Style/SymbolArray

    TAG_COLORS = %w(red orange yellow olive green teal blue
                    violet purple pink brown grey black).freeze

    def initialize
      @path_params_blacklist = PATH_PARAMS_BLACKLIST.dup
    end

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
      validate_rule(rule, block)

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
      validate_rule(rule, block)

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
    #   ApiSampler.configure do |config|
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

    # Set maxumum number of samples collected per time inteval.
    #
    # @example Collect at most 100 samples per day
    #   ApiSampler.configure do |config|
    #     config.samples_quota count: 100, per: 1.day
    #   end
    #
    # @param count [Integer]
    #   the maximum number of collected samples per specified duration.
    # @param per [ActiveSupport::Duration]
    #   the duration during which at most `count` samples can be collected.
    #
    # @return [void]
    #
    # @raise [ArgumentError] if provided arguments of invalid types.
    def samples_quota(count:, per:)
      raise ArgumentError, "`count' must be an Integer" unless
        count.is_a?(Integer)
      raise ArgumentError, "`per' must be an ActiveSupport::Duration" unless
        per.is_a?(ActiveSupport::Duration)

      @samples_quota_count = count
      @samples_quota_duration = per
    end

    # @return [Integer, nil]
    #   the maximum number of collected samples per {samples_quota_duration}.
    attr_reader :samples_quota_count

    # @return [ActiveSupport::Duration, nil]
    #   the duration during which at most {samples_quota_count} samples can be
    #   collected.
    attr_reader :samples_quota_duration

    # Tag matched requests with the specified labels.
    #
    # @example Tag slow requests with the tag 'slow':
    #   ApiSampler.configure do |config|
    #     config.tag_with(:slow) { |request| request.time > 200 }
    #   end
    #
    # @example Assigning color to tags:
    #   ApiSampler.configure do |config|
    #     config.tag_with(:deprecated, %r{^/api/v1/.*}, color: 'red')
    #   end
    #
    # @return [void]
    # @raise [ArgumentError] if arguments are invalid.
    #
    # @overload tag_with(tag, rule)
    #   @param tag [#to_s]
    #     a non-blank label which should tag matching requests.
    #   @param (see ApiSampler::RequestMatcher#initialize)
    #   @param color [#to_s]
    #     an optional tag color. See {::TAG_COLORS} for the list of
    #     available color names.
    # @overload tag_with(tag)
    #   @param tag [#to_s]
    #     a non-blank label which should tag matching requests.
    #   @param color [#to_s]
    #     an optional tag color. See {::TAG_COLORS} for the list of
    #     available color names.
    #
    #   @yield [request]
    #     block which takes the request and returns whether that request
    #     matches.
    #   @yieldparam request [Rack::Request] the current request.
    #   @yieldreturn [Boolean]
    #
    # @note rules defined here may be overriden by the rules defined in
    #   {#deny}.
    def tag_with(tag, rule = nil, color: nil, &block)
      validate_rule(rule, block)

      request_tags << RequestTag.new(tag, RequestMatcher.new(rule || block))
      tag_colors[tag.to_s] = color.to_s.strip unless color.blank?
    end

    # @!attribute [r] request_tags
    # @return [Array<RequestMatcher>]
    #   the set of pairs (tag, rule).
    def request_tags
      @request_tags ||= []
    end

    # @!attribute [r] tag_colors
    # @return [{ #to_s => String}] a mapping from tags to colors.
    def tag_colors
      @tag_colors ||= {}
    end

    # @param tag [#to_s] the tag name.
    # @return [String, nil]
    #   the color assigned to the tag, if any (and the assigned color is a
    #   known color from {::TAG_COLORS}), nil otherwise.
    def tag_color(tag)
      color = tag_colors[tag.to_s]

      return if color.nil?
      return unless TAG_COLORS.include?(color)

      color
    end

    # List of keys to exclude from the path parameters of the request.
    # Keys from {PATH_PARAMS_BLACKLIST} are excluded by default.
    #
    # @example Exclude :id from path parameters
    #   ApiSampler.configure do |config|
    #     config.path_params_blacklist = %i(id)
    #   end
    #
    # @example Don't exclude any parameters from path parameters
    #   ApiSampler.configure do |config|
    #     config.path_params_blacklist = nil
    #   end
    #
    # @see PATH_PARAMS_BLACKLIST
    #
    # @return [<Symbol>, nil]
    attr_reader :path_params_blacklist

    def path_params_blacklist=(blacklisted_params)
      @path_params_blacklist = Array(blacklisted_params)
    end

    private

    def validate_rule(rule, block)
      raise ArgumentError, 'either rule or block should be specified' if
        (rule.nil? && block.nil?) || (rule.present? && block.present?)
    end
  end
end
