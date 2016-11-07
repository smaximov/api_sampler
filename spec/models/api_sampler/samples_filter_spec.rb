# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::SamplesFilter do
  describe '#initialize' do
    context 'when :tags or :path_params are nil' do
      let(:options) { Hash[] }

      it do
        expect {
          described_class.new(options)
        }.not_to raise_error
      end
    end

    describe ':tags' do
      let(:options) { Hash['tags' => tags] }

      context 'with valid values' do
        let(:tags) { %w(1 2 3) }

        it 'converts tags to integers' do
          filter = described_class.new(options)
          expect(filter.tags).to eq([1, 2, 3])
        end
      end

      context 'when empty' do
        let(:tags) { [] }

        it 'is valid' do
          filter = described_class.new(options)
          expect(filter.tags).to eq([])
        end
      end

      context 'with blank tags' do
        let(:tags) { ['', '1', ' ', '2', "\n"] }

        it 'skips them' do
          filter = described_class.new(options)
          expect(filter.tags).to eq([1, 2])
        end
      end

      context 'when not an array or nil' do
        let(:tags) { 'not an array' }

        it do
          expect {
            described_class.new(options)
          }.to raise_error(ArgumentError, /tags/)
        end
      end

      context 'when cannot be cast to integers' do
        let(:tags) { %w(2 3 not_an_integer) }

        it do
          expect {
            described_class.new(options)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe ':path_params' do
      let(:options) { Hash['path_params' => path_params] }

      context 'when not an array or nil' do
        let(:path_params) { 'not an array' }

        it do
          expect {
            described_class.new(options)
          }.to raise_error(ArgumentError, /path_params/)
        end
      end

      context 'when param names or values has surrounding whitespace' do
        let(:path_params) { [Hash['param' => ' id ', 'value' => ' 1 ']] }
        let(:expected) { [Hash['param' => 'id', 'value' => '1']] }

        it 'strips surrounding whitespace' do
          filter = described_class.new(options)
          expect(filter.path_params).to eq(expected)
        end
      end

      context 'when param names or values are blank' do
        let(:path_params) do
          [{ 'param' => 'id', 'value' => '1' },
           { 'param' => 'id' }, { 'param' => ' ', 'value' => '1' }]
        end
        let(:expected) { [Hash['param' => 'id', 'value' => '1']] }

        it 'rejects such params' do
          filter = described_class.new(options)
          expect(filter.path_params).to eq(expected)
        end
      end
    end
  end
end
