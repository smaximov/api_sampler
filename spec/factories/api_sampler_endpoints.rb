# frozen_string_literal: true

FactoryGirl.define do
  factory :endpoint, class: 'ApiSampler::Endpoint' do
    sequence(:path) { |n| "/api/v1/endpoint_#{n}" }
    request_method { ApiSampler::HTTP_METHODS.sample }
  end
end
