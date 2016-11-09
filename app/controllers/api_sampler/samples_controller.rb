# frozen_string_literal: true

module ApiSampler
  class SamplesController < ApplicationController
    before_action :set_endpoint, only: %i(index delete)
    before_action :set_sample, only: %i(request_body response_body_)

    def index
      query = ApiSampler::SampleQuery.new(@endpoint.samples)

      @samples_filter = ApiSampler::SamplesFilter.new(samples_filter_params)
      @sorter = ApiSampler::Sample.sort_with(params)
      @samples = query.with_filter(@samples_filter)
                      .order(@sorter.order)
                      .page(params[:page])
    end

    def delete
      @endpoint.samples.where(id: params[:ids]).delete_all
      redirect_to api_sampler.endpoint_samples_path(@endpoint)
    end

    def request_body
      render plain: @sample.request_body
    end

    # ActionController already has `#response_body`, so we need to pick
    # another name for the action, hence the trailing underscore.
    def response_body_
      render plain: @sample.response_body
    end

    private

    def set_endpoint
      @endpoint = ApiSampler::Endpoint.find(params[:endpoint_id])
    end

    def set_sample
      @sample = ApiSampler::Sample.find(params[:id])
    end

    def samples_filter_params
      params
        .fetch(:samples_filter, tags: [], path_params: [])
        .permit(tags: [], path_params: %i(param value))
    end
  end
end
