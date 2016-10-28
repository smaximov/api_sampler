# frozen_string_literal: true

module ApiSampler
  # Holds conditions used when filtering samples.
  class SamplesFilter
    include ::ActiveAttr::Model

    attribute :tags, default: []
  end
end
