# frozen_string_literal: true

module ApiSampler
  # Holds conditions used when filtering samples.
  class SamplesFilter
    include ::ActiveAttr::Model

    attribute :tags, default: []

    # @param options [Hash] filter conditions.
    # @option options [<String>] :tags
    #   the list of tags IDs.
    #
    #   if `:tags` is not a list or contains values that cannot be safely
    #   cast to integers (sans blank values), {ArgumentError} is raised.
    #
    # @raise [ArgumentError]
    #   if arguments are invalid.
    def initialize(options)
      tags = cast_tags(options['tags'])
      super(tags: tags)
    end

    private

    def cast_tags(tags)
      raise ArgumentError, 'Expected an array' unless
        tags.is_a?(Array)

      tags.reject(&:blank?).map { |tag| Integer(tag, 10) }
    end
  end
end
