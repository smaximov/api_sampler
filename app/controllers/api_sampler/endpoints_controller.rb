# frozen_string_literal: true

module ApiSampler
  class EndpointsController < ApplicationController
    def index
      relation = ApiSampler::Endpoint.all
      query = EndpointQuery.new(relation)

      @sorter = ApiSampler::Endpoint.sort_with(params)
      @endpoints = query.having_any_samples
                        .order(@sorter.order)
                        .page(params[:page])
    end
  end
end
