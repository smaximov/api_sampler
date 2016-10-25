# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::Configuration do
  describe '#allow' do
    context 'when both rule and block are absent' do
      it do
        expect {
          subject.allow
        }.to raise_error(ArgumentError, /rule or block should be specified/)
      end
    end

    context 'when both rule and block are specified' do
      it do
        expect {
          subject.allow(/foo/) { |_request| true }
        }.to raise_error(ArgumentError, /rule or block should be specified/)
      end
    end

    context 'when only rule is specified' do
      it do
        expect {
          subject.allow(/foo/)
        }.not_to raise_error
      end
    end

    context 'when only block is given' do
      it do
        expect {
          subject.allow { |_request| true }
        }.not_to raise_error
      end
    end
  end

  describe '#deny' do
    context 'when both rule and block are absent' do
      it do
        expect {
          subject.deny
        }.to raise_error(ArgumentError, /rule or block should be specified/)
      end
    end

    context 'when both rule and block are specified' do
      it do
        expect {
          subject.deny(/foo/) { |_request| true }
        }.to raise_error(ArgumentError, /rule or block should be specified/)
      end
    end

    context 'when only rule is specified' do
      it do
        expect {
          subject.deny(/foo/)
        }.not_to raise_error
      end
    end

    context 'when only block is given' do
      it do
        expect {
          subject.deny { |_request| true }
        }.not_to raise_error
      end
    end
  end

  describe '#samples_expire_in' do
    context 'when provided with nil' do
      it do
        expect {
          subject.samples_expire_in nil
        }.not_to raise_error
      end
    end

    context 'when provided with ActiveSupport::Duration' do
      it do
        expect {
          subject.samples_expire_in 2.days
        }.not_to raise_error
      end
    end

    context 'when provided with an argument of invalid type' do
      it do
        expect {
          subject.samples_expire_in 2
        }.to raise_error(ArgumentError)
      end
    end
  end
end
