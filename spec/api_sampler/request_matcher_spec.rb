# frozen_string_literal: true

require 'byebug'

RSpec.describe ApiSampler::RequestMatcher do
  subject { described_class.new(rule) }

  def request(*args, **kwargs)
    Rack::Request.new(Rack::MockRequest.env_for(*args, **kwargs))
  end

  context 'when the rule has invalid type' do
    let(:rule) { nil }

    it do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  describe '#matches?' do
    context 'with a Regexp rule' do
      let(:rule) { %r{^/api/v1} }

      context 'when the regexp matches the request path' do
        it do
          is_expected.to be_matches(request('http://foo.bar/api/v1/kittens'))
        end
      end

      context "when the regexp doesn't match the request path" do
        it do
          is_expected.not_to be_matches(request('http://example.com/some/url'))
        end
      end
    end

    context 'with a #call-able rule' do
      let(:rule) { ->(r) { r.body.read == 'input' } }

      context 'when the callable returns true' do
        it do
          is_expected.to be_matches(request('http://foo.bar', input: 'input'))
        end
      end

      context 'when the callable returns false' do
        it do
          is_expected.not_to be_matches(request('http://foo.bar'))
        end
      end
    end
  end
end
