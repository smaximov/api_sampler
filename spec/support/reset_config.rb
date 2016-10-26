# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example, reset_config: true) do |example|
    conf, ApiSampler.config = ApiSampler.config, ApiSampler::Configuration.new
    begin
      example.run
    ensure
      ApiSampler.config = conf
    end
  end
end
