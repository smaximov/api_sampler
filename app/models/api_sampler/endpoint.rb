# frozen_string_literal: true
module ApiSampler
  class Endpoint < ApplicationRecord
    has_many :samples

    validates :path, presence: true
    validates :path, uniqueness: true
  end
end
