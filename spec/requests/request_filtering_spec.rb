# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Request filtering', type: :request, reset_config: true do
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

  context 'blacklisting' do
    context 'with a single matching rule' do
      configure do |config|
        # we need to allow some rules first
        config.allow %r{^/api/v1}
        # matches `kthnxbye` request
        config.deny(&:post?)
      end

      it 'allows not blacklisted request' do
        expect {
          echo_get
        }.to change { ApiSampler::Sample.count }.by(1)
      end

      it 'denies the matched request' do
        expect {
          kthnxbye
        }.not_to change { ApiSampler::Sample.count }
      end
    end
  end

  context 'samples quota' do
    configure do |config|
      config.allow %r{^/api/v1}
      config.samples_quota count: 2, per: 2.days
    end

    before do
      FactoryGirl.create_list(:sample, 2, created_at: 1.day.ago)
    end

    context 'when exceeding the quota' do
      it do
        expect {
          kthnxbye
        }.not_to change { ApiSampler::Sample.count }
      end
    end

    context 'when meeting the quota' do
      it do
        travel 2.days do
          expect {
            kthnxbye
          }.to change { ApiSampler::Sample.count }.by(1)
        end
      end
    end
  end
end
