# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example, reset_config: true) do |example|
    begin
      conf, ApiSampler.config = ApiSampler.config, ApiSampler::Configuration.new
      example.run
    ensure
      ApiSampler.config = conf
    end
  end
end
