# frozen_string_literal: true

class CreateApiSamplerSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :api_sampler_samples do |t|
      t.references :endpoint, foreign_key: { to_table: :api_sampler_endpoints },
                              null: false, index: true
      t.text :request_method, null: false, index: true
      t.text :query, null: false
      t.text :request_body, null: false
      t.text :response_body, null: false

      t.timestamps
    end
  end
end
