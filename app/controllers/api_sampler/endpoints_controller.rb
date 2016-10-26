# frozen_string_literal: true

module ApiSampler
  class EndpointsController < ApplicationController
    def index
      relation = ApiSampler::Endpoint.order(updated_at: :desc)
      query = EndpointQuery.new(relation)

      @endpoints = query.having_any_samples
    end
  end
end
