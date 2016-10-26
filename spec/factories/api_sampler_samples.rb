# frozen_string_literal: true
FactoryGirl.define do
  factory :sample, class: 'ApiSampler::Sample' do
    endpoint
    query 'foo=bar'
    request_body 'request body'
    response_body 'response body'
  end
end
