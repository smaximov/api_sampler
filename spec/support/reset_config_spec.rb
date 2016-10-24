# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Reset config', reset_config: true do
  before(:all) { @initial_config = ApiSampler.config }

  it 'resets config on each example' do
    expect(ApiSampler.config).not_to be(@initial_config)
  end

  after(:all) do
    expect(ApiSampler.config).to be(@initial_config)
  end
end
