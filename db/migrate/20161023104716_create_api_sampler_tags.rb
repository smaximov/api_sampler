# frozen_string_literal: true

class CreateApiSamplerTags < ActiveRecord::Migration[5.0]
  def change
    create_table :api_sampler_tags do |t|
      t.text :name, null: false
      t.timestamps
    end
    add_index :api_sampler_tags, :name, unique: true
  end
end
