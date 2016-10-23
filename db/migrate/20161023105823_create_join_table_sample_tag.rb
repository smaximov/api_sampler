# frozen_string_literal: true

class CreateJoinTableSampleTag < ActiveRecord::Migration[5.0]
  TABLE_NAME = :api_sampler_samples_tags

  def change
    create_join_table :samples, :tags, table_name: TABLE_NAME do |t|
      t.references :sample, foreign_key: { to_table: :api_sampler_samples },
                            null: false, index: true
      t.references :tag, foreign_key: { to_table: :api_sampler_tags },
                         null: false, index: true
      t.index %i(sample_id tag_id), unique: true
    end
  end
end
