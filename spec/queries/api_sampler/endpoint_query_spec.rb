# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::EndpointQuery do
  describe '#having_any_samples' do
    # Create two endpoints, one of them has two samples,
    # the other has none.
    let!(:endpoint) do
      FactoryGirl.create(:endpoint, create_samples: true, count: 2)
    end

    before do
      FactoryGirl.create(:endpoint)
    end

    let(:endpoints_with_samples) { subject.having_any_samples.to_a }

    it do
      expect(endpoints_with_samples.size).to eq(1)
      expect(endpoints_with_samples).to contain_exactly(endpoint)
      expect(endpoints_with_samples.first.samples_count).to eq(2)
    end
  end
end
