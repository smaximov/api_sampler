# frozen_string_literal: true

FactoryGirl.define do
  factory :api_sampler_endpoint, class: 'ApiSampler::Endpoint' do
    path { |n| "/api/v1/endpoint#{n}" }
  end
end
