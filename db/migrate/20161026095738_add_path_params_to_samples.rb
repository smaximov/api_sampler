# frozen_string_literal: true

class AddPathParamsToSamples < ActiveRecord::Migration[5.0]
  def change
    add_column :api_sampler_samples, :path_params, :hstore, null: false
  end
end
