# frozen_string_literal: true
module ApiSampler
  class Sample < ApplicationRecord
    include Sortable

    sortable :created_at
    sortable_default column: :created_at, direction: :desc

    paginates_per 20

    belongs_to :endpoint, touch: true
    has_and_belongs_to_many :tags

    validates :endpoint_id, presence: true
    validates :query, length: { minimum: 0, allow_nil: false }
    validates :request_body, length: { minimum: 0, allow_nil: false }
    validates :response_body, length: { minimum: 0, allow_nil: false }
  end
end
