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

      PARAMS_WHERE = <<-SQL.squish
        path_params @> hstore(ARRAY[:params], ARRAY[:values])
      SQL

      # Return samples filtered using form conditions.
      # @param filter [ApiSampler::SamplesFilter] the samples filter.
      def with_filter(filter)
        tags, path_params = filter.tags, filter.path_params

        scope = self
        scope = scope.distinct.joins(TAGS_JOIN).where(TAGS_WHERE, tags) unless
          tags.blank?
        scope = scope.where(PARAMS_WHERE, params_values(path_params)) unless
          path_params.blank?

        scope
      end

      private

      def params_values(path_params)
        params, values = [], []

        path_params.each do |param|
          params << param['param']
          values << param['value']
        end

        { params: params, values: values }
      end
    end
  end
end
