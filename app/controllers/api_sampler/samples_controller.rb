# frozen_string_literal: true

module ApiSampler
  class SamplesController < ApplicationController
    def index
      @sorter = ApiSampler::Sample.sort_with(params)
      @endpoint = ApiSampler::Endpoint.find(params[:endpoint_id])
      @samples = @endpoint.samples.order(@sorter.order).page(params[:page])
    end
  end
end
