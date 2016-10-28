# frozen_string_literal: true

module ApiSampler
  module SamplesHelper
    def tags(samples_filter)
      options_from_collection_for_select(ApiSampler::Tag.all,
                                         :id, :name, samples_filter.tags)
    end
  end
end
