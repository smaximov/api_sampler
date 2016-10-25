# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Samples expiration', type: :request, reset_config: true do
  before do
    # These samples are kept
    FactoryGirl.create_list(:sample, 2, created_at: 12.hours.ago)
    # This sample should be destroyed
    FactoryGirl.create(:sample, tags: [FactoryGirl.create(:tag)],
                                created_at: 2.days.ago)
  end

  configure do |config|
    config.samples_expire_in 1.day
  end

  it 'deletes expired samples' do
    expect {
      kthnxbye
    }.to change { ApiSampler::Sample.count }.from(3).to(2)
  end

  it 'deletes associated records from api_sampler_samples_tags' do
    expect {
      kthnxbye
    }.to change { samples_tags_count }.from(1).to(0)
  end
end
