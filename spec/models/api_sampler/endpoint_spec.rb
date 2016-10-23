# frozen_string_literal: true

require 'rails_helper'

module ApiSampler
  RSpec.describe Endpoint, type: :model do
    subject { FactoryGirl.build(:api_sampler_endpoint) }

    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_uniqueness_of(:path) }
  end
end
