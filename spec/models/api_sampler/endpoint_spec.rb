# frozen_string_literal: true

require 'rails_helper'

module ApiSampler
  RSpec.describe Endpoint, type: :model do
    subject { FactoryGirl.build(:endpoint) }

    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_uniqueness_of(:path) }
    it { is_expected.to have_many(:samples) }
  end
end
