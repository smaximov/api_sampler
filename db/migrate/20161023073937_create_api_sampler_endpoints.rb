# frozen_string_literal: true
class CreateApiSamplerEndpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :api_sampler_endpoints do |t|
      t.text :path, null: false

      t.timestamps
    end
    add_index :api_sampler_endpoints, :path, unique: true
  end
end
