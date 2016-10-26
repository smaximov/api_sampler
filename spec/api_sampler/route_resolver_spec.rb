# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::RouteResolver, reset_config: true do
  include RSpec::Rails::ControllerExampleGroup

  let(:route_resolver) { described_class.new(routes.router) }

  controller do
    def dummy; end
  end

  before do
    routes.draw do
      get '/api/:id/', to: 'anonymous#dummy'
    end
  end

  describe '#resolve' do
    context "when request doesn't match any route" do
      let(:request) { mock_request('/no/match') }

      it do
        expect(route_resolver.resolve(request)).to be_nil
      end

      it do
        expect { |block|
          route_resolver.resolve(request, &block)
        }.not_to yield_control
      end
    end

    context 'when request matches' do
      let(:request) { mock_request('/api/1') }

      it do
        expect { |block|
          route_resolver.resolve(request, &block)
        }.to yield_control
      end

      it do
        route = route_resolver.resolve(request)
        expect(route.pattern).to eq('/api/:id(.:format)')
      end

      it 'contains path parameters' do
        route = route_resolver.resolve(request)
        expect(route.parameters).to include(id: '1')
      end

      context 'path parameters blacklisting' do
        context 'with the default blacklist' do
          it "doesn't include :action and :controller" do
            route = route_resolver.resolve(request)
            expect(route.parameters).not_to include(:action, :controller)
          end
        end

        context 'with the empty blacklist' do
          configure do |config|
            config.path_params_blacklist = nil
          end

          it 'includes :action and :controller' do
            route = route_resolver.resolve(request)
            expect(route.parameters).to include(:action, :controller)
          end
        end

        context 'with a custom blacklist' do
          configure do |config|
            config.path_params_blacklist = :id
          end

          it "doesn't include blacklisted parameters" do
            route = route_resolver.resolve(request)
            expect(route.parameters).not_to include(:id)
          end
        end
      end
    end
  end
end
