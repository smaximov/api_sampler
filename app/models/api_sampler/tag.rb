# frozen_string_literal: true
module ApiSampler
  class Tag < ApplicationRecord
    has_and_belongs_to_many :samples

    validates :name, presence: true
    validates :name, uniqueness: true
  end
end
