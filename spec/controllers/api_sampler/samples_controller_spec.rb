# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::SamplesController, type: :controller do
  let(:endpoint) { FactoryGirl.create(:endpoint) }

  routes { ApiSampler::Engine.routes }

  describe 'GET index' do
    context 'without the tags filter' do
      it 'is successful' do
        expect {
          get :index, params: { endpoint_id: endpoint.id }
        }.not_to raise_error
      end
    end
  end
end
