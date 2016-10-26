# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic samples collecting', type: :request, reset_config: true do
  subject { ApiSampler::Sample.last }
  let(:response_body) do
    JSON.parse(subject.response_body, symbolize_names: true)
  end

  configure do |config|
    config.allow %r{^/api/v1/}
  end

  def perform_request
    post '/api/v1/kthnxbye?foo=bar', params: { bar: :baz }
  end

  it 'creates a new ApiSampler::Sample' do
    expect { perform_request }.to change { ApiSampler::Sample.count }.by(1)
    expect(subject.endpoint.path).to eq('/api/v1/kthnxbye(.:format)')
    expect(response_body).to eq(reply: 'kthnxbye')
    expect(subject.endpoint.request_method).to eq('POST')
    expect(subject.query).to eq('foo=bar')
    expect(subject.request_body).to eq('bar=baz')
  end

  context 'first request to the endpoint' do
    it 'creates a new ApiSampler::Endpoint' do
      expect { perform_request }.to change { ApiSampler::Endpoint.count }.by(1)
    end
  end

  context 'subsequent requests to the same endpoint' do
    it "doesn't create a new ApiSampler::Endpoint" do
      perform_request
      expect { perform_request }.not_to change { ApiSampler::Endpoint.count }
    end
  end
end
