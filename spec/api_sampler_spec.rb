# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler do
  describe '.configure' do
    context 'when block is given' do
      it do
        expect { |block|
          ApiSampler.configure(&block)
        }.to yield_with_args(ApiSampler.config)
      end
    end

    context 'when block is not given' do
      it do
        expect {
          ApiSampler.configure
        }.to raise_error(ArgumentError)
      end
    end
  end
end
