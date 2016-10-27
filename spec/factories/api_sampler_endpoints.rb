# frozen_string_literal: true

FactoryGirl.define do
  factory :endpoint, class: 'ApiSampler::Endpoint' do
    transient do
      create_samples false
      count 0..10
    end

    sequence(:path) { |n| "/api/v1/endpoint_#{n}" }
    request_method { ApiSampler::HTTP_METHODS.sample }

    after(:create) do |endpoint, evaluator|
      count = evaluator.count
      count = count..count unless count.is_a?(Range)

      create_list(:sample, rand(count), endpoint: endpoint) if
        evaluator.create_samples
    end
  end
end
