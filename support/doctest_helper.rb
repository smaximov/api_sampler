# frozen_string_literal: true

require 'rack'

require 'lib/api_sampler/request_matcher'

YARD::Doctest.configure do |doctest|
  doctest.skip 'ApiSampler::Configuration'
end
