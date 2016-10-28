# frozen_string_literal: true

require 'rails_helper'

module ApiSampler
  RSpec.describe Endpoint, type: :model do
    subject { FactoryGirl.build(:endpoint) }

    it { is_expected.to validate_presence_of(:path) }
    it do
      is_expected.to validate_uniqueness_of(:path).scoped_to(:request_method)
    end
    it { is_expected.to have_db_index(:path) }
    it { is_expected.to have_db_index(%i(request_method path)).unique }
    it { is_expected.to validate_presence_of(:request_method) }
    it do
      is_expected.to validate_inclusion_of(:request_method)
        .in_array(ApiSampler::HTTP_METHODS)
    end
    it { is_expected.to have_many(:samples) }

    it { is_expected.to be_kind_of(ApiSampler::Sortable) }
  end
end
