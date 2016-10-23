# frozen_string_literal: true
require 'rails_helper'

module ApiSampler
  RSpec.describe Sample, type: :model do
    subject { FactoryGirl.build(:sample) }

    it { is_expected.to belong_to(:endpoint) }
    it { is_expected.to have_and_belong_to_many(:tags) }

    it { is_expected.to validate_presence_of(:endpoint_id) }
    it { is_expected.to have_db_index(:endpoint_id) }
    it { is_expected.to validate_presence_of(:request_method) }
    it { is_expected.to have_db_index(:request_method) }
    it do
      is_expected.to validate_inclusion_of(:request_method)
        .in_array(ApiSampler::HTTP_METHODS)
    end
    it { is_expected.to validate_presence_of(:query) }
    it { is_expected.to validate_presence_of(:request_body) }
    it { is_expected.to validate_presence_of(:response_body) }
  end
end
