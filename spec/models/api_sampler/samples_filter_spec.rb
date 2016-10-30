# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::SamplesFilter do
  describe '#initialize' do
    context 'with valid values' do
      let(:options) { Hash['tags' => %w(1 2 3)] }

      it 'converts tags to integers' do
        filter = described_class.new(options)
        expect(filter.tags).to eq([1, 2, 3])
      end
    end

    context 'with an empty list of tags' do
      let(:options) { Hash['tags' => []] }

      it 'is valid' do
        filter = described_class.new(options)
        expect(filter.tags).to eq([])
      end
    end

    context 'with blank tags' do
      let(:options) { Hash['tags' => ['', '1', ' ', '2', "\n"]] }

      it 'skips them' do
        filter = described_class.new(options)
        expect(filter.tags).to eq([1, 2])
      end
    end

    context 'when :tags is not an array' do
      let(:options) { Hash[] }

      it do
        expect {
          described_class.new(options)
        }.to raise_error(ArgumentError)
      end
    end

    context 'when tags cannot be cast to integers' do
      let(:options) { Hash['tags' => %w(2 3 not_an_integer)] }

      it do
        expect {
          described_class.new(options)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
