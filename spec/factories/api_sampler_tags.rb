# frozen_string_literal: true
FactoryGirl.define do
  factory :tag, class: 'ApiSampler::Tag' do
    sequence(:name) { |n| "tag_#{n}" }
  end
end
