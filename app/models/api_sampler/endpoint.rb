# frozen_string_literal: true
module ApiSampler
  class Endpoint < ApplicationRecord
    has_many :samples

    validates :path, presence: true
    validates :path, uniqueness: { scope: :request_method }
    validates :request_method, presence: true
    validates :request_method, inclusion: ApiSampler::HTTP_METHODS
  end
end
