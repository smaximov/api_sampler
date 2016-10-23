# frozen_string_literal: true

FactoryGirl.define do
  factory :endpoint, class: 'ApiSampler::Endpoint' do
    path { |n| "/api/v1/endpoint#{n}" }
  end
end
