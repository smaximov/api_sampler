# frozen_string_literal: true

module ApiSampler
  class EndpointQuery < SimpleDelegator
    def initialize(relation = ApiSampler::Endpoint.all)
      super(relation.extending(Scopes))
    end

    module Scopes
      HAVING_ANY_SAMPLE_SELECT = <<-SQL.squish
        api_sampler_endpoints.*, COUNT(api_sampler_samples.*) as samples_count
      SQL

      # Return endpoints that have any samples, count the samples along the way.
      def having_any_samples
        select(HAVING_ANY_SAMPLE_SELECT)
          .left_joins(:samples)
          .group(:id)
          .having('COUNT(api_sampler_samples.*) > 0')
      end
    end
  end
end
