# frozen_string_literal: true
module ApiSampler
  class Endpoint < ApplicationRecord
    include Sortable

    sortable :path, :request_method
    sortable :samples_count, validate: false
    sortable_default column: :path

    has_many :samples

    validates :path, presence: true
    validates :path, uniqueness: { scope: :request_method }
    validates :request_method, presence: true
    validates :request_method, inclusion: ApiSampler::HTTP_METHODS
  end
end
