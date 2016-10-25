# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Samples tagging', type: :request, reset_config: true do
  configure do |config|
    config.allow(/.*/)
  end

  def kthnxbye
    post '/api/v1/kthnxbye'
  end

  def samples_tags_count
    sql = 'SELECT count(*) from api_sampler_samples_tags'
    result = ActiveRecord::Base.connection.execute(sql)
    result.first['count']
  end

  context 'with a matching tagging rule' do
    configure do |config|
      config.tag_with('tag', &:post?)
    end

    it do
      expect {
        kthnxbye
      }.to change { samples_tags_count }.by(1)
    end
  end

  context 'with no matching tagging rules' do
    it do
      expect {
        kthnxbye
      }.not_to change { samples_tags_count }
    end
  end

  context 'with overlapping rules that create the same tag' do
    configure do |config|
      config.tag_with('tag', /kthnxbye/)
      config.tag_with('tag', &:post?)
    end

    it 'requests the tag only once' do
      tag = ApiSampler::Tag.create(name: 'tag')
      allow(ApiSampler::Tag).to receive(:find_or_create_by!).and_return(tag)

      kthnxbye

      expect(ApiSampler::Tag).to have_received(:find_or_create_by!)
        .with(name: 'tag').once
    end
  end
end
