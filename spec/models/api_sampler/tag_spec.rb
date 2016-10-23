# frozen_string_literal: true
require 'rails_helper'

module ApiSampler
  RSpec.describe Tag, type: :model do
    subject { FactoryGirl.build(:tag) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to have_db_index(:name) }
  end
end
