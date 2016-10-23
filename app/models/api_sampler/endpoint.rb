# frozen_string_literal: true
module ApiSampler
  class Endpoint < ApplicationRecord
    validates :path, presence: true
    validates :path, uniqueness: true
  end
end
