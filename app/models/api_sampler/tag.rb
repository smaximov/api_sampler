# frozen_string_literal: true
module ApiSampler
  class Tag < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
  end
end
