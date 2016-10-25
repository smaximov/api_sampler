# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::RequestTag do
  describe '#initialize' do
    context 'with invalid arguments' do
      it do
        expect {
          described_class.new('', ApiSampler::RequestMatcher.new(/.*/))
        }.to raise_error(ArgumentError, /blank/)
      end

      it do
        expect {
          described_class.new('tag', /.*/)
        }.to raise_error(ArgumentError, /RequestMatcher/)
      end
    end

    context 'with valid arguments' do
      it do
        expect {
          described_class.new('tag', ApiSampler::RequestMatcher.new(/.*/))
        }.not_to raise_error
      end
    end
  end
end
