# frozen_string_literal: true
require 'api_sampler/engine'
require 'api_sampler/configuration'
require 'api_sampler/request_matcher'

# Collect samples (request/response pairs) for API endpoints of your Rails app.
# @todo Write a proper description, excerpt from README should do.
module ApiSampler
  # Valid HTTP methods.
  HTTP_METHODS = %w(GET HEAD PUT POST DELETE OPTIONS PATCH LINK UNLINK).freeze

  # @return [Configuration] the configuration of **api_sampler**.
  # @!scope module
  mattr_accessor :config, instance_accessor: false do
    Configuration.new
  end

  module_function

  # Configure **api_sampler**.
  #
  # @example
  #   ApiSampler.configure do |config|
  #     # configuration goes here
  #     config.allow %r{^/api/v1/}
  #     # more configuration...
  #   end
  #
  # @see Configuration More examples of configuration.
  #
  # @yield [config]
  # @yieldparam config [Configuration] the current configuration.
  # @yieldreturn [void]
  # @return [void]
  #
  # @raise [ArgumentError] if block is not given.
  def configure
    raise ArgumentError, 'block is required' unless block_given?
    yield config
  end
end
