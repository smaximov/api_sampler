# frozen_string_literal: true

module ApiSampler
  class SampleQuery < SimpleDelegator
    def initialize(relation = ApiSampler::Sample.all)
      super(relation.extending(Scopes))
    end

    module Scopes
      TAGS_JOIN = <<-SQL.squish
        inner join api_sampler_samples_tags
          on (api_sampler_samples.id = api_sampler_samples_tags.sample_id)
      SQL

      TAGS_WHERE = <<-SQL.squish
        api_sampler_samples_tags.tag_id in (?)
      SQL

      # Return samples filtered using form conditions.
      # @param filter [ApiSampler::SamplesFilter] the samples filter.
      def with_filter(filter)
        tags = filter.tags

        scope = self
        scope = scope.distinct.joins(TAGS_JOIN).where(TAGS_WHERE, tags) unless
          tags.blank?

        scope
      end
    end
  end
end
