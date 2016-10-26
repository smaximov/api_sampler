# frozen_string_literal: true
module ApiSampler
  class Sample < ApplicationRecord
    belongs_to :endpoint
    has_and_belongs_to_many :tags

    validates :endpoint_id, presence: true
    validates :query, length: { minimum: 0, allow_nil: false }
    validates :request_body, length: { minimum: 0, allow_nil: false }
    validates :response_body, length: { minimum: 0, allow_nil: false }
  end
end
