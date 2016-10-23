# frozen_string_literal: true
require 'api_sampler/engine'

# Collect samples (request/response pairs) for API endpoints of your Rails app.
module ApiSampler
  # Valid HTTP methods.
  HTTP_METHODS = %w(GET HEAD PUT POST DELETE OPTIONS PATCH LINK UNLINK).freeze
end
