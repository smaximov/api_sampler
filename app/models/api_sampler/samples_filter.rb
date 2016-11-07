# frozen_string_literal: true

module ApiSampler
  # Holds conditions used when filtering samples.
  class SamplesFilter
    include ::ActiveAttr::Model

    attribute :tags, default: []
    attribute :path_params, default: []

    # @param options [Hash] filter conditions.
    # @option options [<String>] :tags
    #   the list of tags IDs.
    #
    #   If `:tags` is not a list or nil, or contains values that cannot be
    #   safely cast to integers (sans blank values), {ArgumentError} is raised.
    # @option options [<{String => String}>] :path_params
    #   the list of hashes if the form
    #   `{ 'param' => 'path param name', 'value' => 'path param value' }`
    #   (blank hash values are ignored).
    #
    #   If `:path_params` is not a list or nil, {ArgumentError} is raised.
    #
    # @raise [ArgumentError]
    #   if arguments are invalid.
    def initialize(options)
      tags = cast_tags(options.fetch('tags', []))
      path_params = cast_path_params(options.fetch('path_params', []))
      super(tags: tags, path_params: path_params)
    end

    private

    def cast_tags(tags)
      raise ArgumentError, 'Expected an array of :tags' unless
        tags.is_a?(Array)

      tags.reject(&:blank?).map { |tag| Integer(tag, 10) }
    end

    def cast_path_params(path_params)
      raise ArgumentError, 'Expected an array of :path_params' unless
        path_params.is_a?(Array)

      path_params
        .map { |p| p.transform_values(&:strip) }
        .reject { |p| p['param'].blank? || p['value'].blank? }
    end
  end
end
