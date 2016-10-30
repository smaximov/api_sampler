# frozen_string_literal: true

module ApiSampler
  module SamplesHelper
    def tags(samples_filter)
      options_for_select(tags_with_colors, samples_filter.tags)
    end

    private

    def tags_with_colors
      ApiSampler::Tag.all.map do |tag|
        [tag.name, tag.id, Hash[class: tag_color(tag.name)]]
      end
    end
  end
end
