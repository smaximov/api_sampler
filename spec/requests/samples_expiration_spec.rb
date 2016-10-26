# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Samples expiration', type: :request, reset_config: true do
  let(:endpoint) { FactoryGirl.create(:endpoint, path: '/foo/bar') }

  before do
    # These samples are kept
    FactoryGirl.create_list(:sample, 2, created_at: 12.hours.ago,
                                        endpoint: endpoint)
    # This sample should be destroyed
    FactoryGirl.create(:sample, tags: [FactoryGirl.create(:tag)],
                                created_at: 2.days.ago,
                                endpoint: endpoint)
  end

  configure do |config|
    config.samples_expire_in 1.day
  end

  context 'without matching requests' do
    it "doesn't delete expired samples" do
      expect {
        kthnxbye
      }.not_to change { endpoint.samples.count }
    end
  end

  context 'with matching requests' do
    configure do |config|
      config.allow(/kthnxbye/)
    end

    it 'deletes expired samples' do
      expect {
        kthnxbye
      }.to change { endpoint.samples.count }.from(3).to(2)
    end

    it 'deletes associated records from api_sampler_samples_tags' do
      expect {
        kthnxbye
      }.to change { samples_tags_count }.from(1).to(0)
    end
  end
end
