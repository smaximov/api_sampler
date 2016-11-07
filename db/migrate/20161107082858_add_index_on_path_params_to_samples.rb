# frozen_string_literal: true

class AddIndexOnPathParamsToSamples < ActiveRecord::Migration[5.0]
  def change
    add_index :api_sampler_samples, :path_params, using: :gist
  end
end
