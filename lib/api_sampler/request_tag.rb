# frozen_string_literal: true

module ApiSampler
  # A Plain Old Ruby Object to hold a tag with the corresponding
  # request matcher.
  #
  # @!method initialize(tag, matcher)
  #   @param tag [#to_s] a non-blank tag.
  #   @param matcher [RequestMatcher]
  #     the corresponding request matcher.
  #
  #   @return [RequestTag]
  #
  #   @raise [ArgumentError] if arguments are invalid.
  #
  # @!attribute [rw] name
  #   @return [#to_s] tag name
  #
  # @!attribute [rw] matcher
  #   @return [RequestMatcher] the corresponding request matcher
  RequestTag = Struct.new('RequestTag', :name, :matcher) do
    def initialize(tag, matcher)
      raise ArgumentError, 'tag cannot be blank' if tag.blank?
      raise ArgumentError, 'matcher must be a ApiSampler::RequestMatcher' unless
        matcher.is_a?(RequestMatcher)

      super(tag.to_s, matcher)
    end
  end
end
