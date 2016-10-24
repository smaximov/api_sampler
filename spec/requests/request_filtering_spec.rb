# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Request filtering', type: :request, reset_config: true do
  subject { ApiSampler::Sample.last }

  def kthnxbye
    post '/api/v1/kthnxbye'
  end

  def echo_get
    get '/api/v1/echo_get?foo=bar'
  end

  it 'rejects all requests by default' do
    expect {
      kthnxbye
    }.not_to change { ApiSampler::Sample.count }
  end

  context 'whitelisting' do
    context 'with a single matching rule' do
      configure do |config|
        # matches the `kthnxbye` request
        config.allow(&:post?)
      end

      it 'allows the request' do
        expect {
          kthnxbye
        }.to change { ApiSampler::Sample.count }.by(1)
      end
    end

    context 'with a set of rules' do
      configure do |config|
        # matches the `kthnxbye` request only
        config.allow(&:post?)
        # matches the `echo_get` request only
        config.allow { |request| request.GET.key?('foo') }
      end

      it 'allows requests matched by any of them' do
        expect {
          kthnxbye
        }.to change { ApiSampler::Sample.count }.by(1)
        expect {
          echo_get
        }.to change { ApiSampler::Sample.count }.by(1)
      end
    end
  end
end
