# frozen_string_literal: true

class MoveRequestMethodToEndpoint < ActiveRecord::Migration[5.0]
  def change
    remove_index :api_sampler_samples, :request_method
    remove_index :api_sampler_endpoints, column: :path, unique: true
    remove_column :api_sampler_samples, :request_method, :text, null: false

    add_column :api_sampler_endpoints, :request_method, :text, null: false
    add_index :api_sampler_endpoints, %i(request_method path), unique: true
    add_index :api_sampler_endpoints, :path
  end
end
