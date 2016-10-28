# frozen_string_literal: true

class ChangeFkOnEndpointsToDeleteCascade < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :api_sampler_samples, column: :endpoint_id
    add_foreign_key :api_sampler_samples, :api_sampler_endpoints,
                    column: :endpoint_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :api_sampler_samples, column: :endpoint_id
    add_foreign_key :api_sampler_samples, :api_sampler_endpoints,
                    column: :endpoint_id
  end
end
