# frozen_string_literal: true

module ApiSampler
  class SamplesController < ApplicationController
    before_action :set_endpoint

    def index
      query = ApiSampler::SampleQuery.new(@endpoint.samples)

      @samples_filter = ApiSampler::SamplesFilter.new(samples_filter_params)
      @sorter = ApiSampler::Sample.sort_with(params)
      @samples = query.with_filter(@samples_filter)
                      .order(@sorter.order)
                      .page(params[:page])
    end

    private

    def set_endpoint
      @endpoint = ApiSampler::Endpoint.find(params[:endpoint_id])
    end

    def samples_filter_params
      params.fetch(:samples_filter, tags: []).permit(tags: [])
    end
  end
end
