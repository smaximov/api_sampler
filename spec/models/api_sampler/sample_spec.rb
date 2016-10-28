# frozen_string_literal: true
require 'rails_helper'

module ApiSampler
  RSpec.describe Sample, type: :model do
    subject { FactoryGirl.build(:sample) }

    it { is_expected.to belong_to(:endpoint).touch(true) }
    it { is_expected.to have_and_belong_to_many(:tags) }

    it { is_expected.to validate_presence_of(:endpoint_id) }
    it { is_expected.to have_db_index(:endpoint_id) }
    it { is_expected.to validate_length_of(:query).is_at_least(0) }
    it { is_expected.to validate_length_of(:request_body).is_at_least(0) }
    it { is_expected.to validate_length_of(:response_body).is_at_least(0) }

    it { is_expected.to be_kind_of(ApiSampler::Sortable) }
  end
end
