# frozen_string_literal: true

module ApiSampler
  class SampleQuery < SimpleDelegator
    def initialize(relation = ApiSampler::Sample.all)
      super(relation.extending(Scopes))
    end

    module Scopes
      JOIN_CLAUSE = <<-SQL.squish
        inner join api_sampler_samples_tags
          on (api_sampler_samples.id = api_sampler_samples_tags.sample_id)
      SQL

      WHERE_CLAUSE = <<-SQL.squish
        api_sampler_samples_tags.tag_id in (?)
      SQL

      # Return samples filtered using form conditions.
      def with_filter(filter)
        # FIXME: proper validation of filter's tags.
        tags = filter.tags.reject(&:blank?).map(&:to_i)

        scope = distinct
        scope = scope.joins(JOIN_CLAUSE).where(WHERE_CLAUSE, tags) unless
          tags.blank?

        scope
      end
    end
  end
end
