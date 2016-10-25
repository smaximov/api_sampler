# frozen_string_literal: true

class ChangeFkOnSamplesTagsToDeleteCascade < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :api_sampler_samples_tags, column: :sample_id
    add_foreign_key :api_sampler_samples_tags, :api_sampler_samples,
                    column: :sample_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :api_sampler_samples_tags, column: :sample_id
    add_foreign_key :api_sampler_samples_tags, :api_sampler_samples,
                    column: :sample_id
  end
end
