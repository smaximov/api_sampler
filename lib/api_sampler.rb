# frozen_string_literal: true

# Bundled dependencies
require 'autoprefixer-rails'
require 'jquery-rails'
require 'less/rails/semantic_ui'

require 'api_sampler/engine'
require 'api_sampler/configuration'
require 'api_sampler/request_matcher'
require 'api_sampler/request_tag'

# Collect samples (request/response pairs) for API endpoints of your Rails app.
#
# ## Installation
#
# Add this line to your application's Gemfile:
#
# ``` ruby
# gem 'api_sampler'
# ```
#
# And then execute:
#
# ``` bash
# $ bundle install
# ```
#
# Finally, you need to run the generator:
#
# ``` bash
# $ rails generate api_sampler:install
# ```
#
# This will create an initializer at `config/initializers/api_sampler.rb`, mount
# {Engine} at `/api_sampler`, copy and run the engine's migrations.
#
# Run the following command to see the list of available options:
#
# ``` bash
# $ rails generate api_sampler:install --help
# ```
#
# ## Configuration.
#
# Edit the provided initializer at `config/initializers/api_sampler.rb`.
#
# See {Configuration} for the list of available configuration options with
# the examples of their usage.
module ApiSampler
  # Valid HTTP methods.
  HTTP_METHODS = %w(GET HEAD PUT POST DELETE OPTIONS PATCH LINK UNLINK).freeze

  # @!attribute [rw] config
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
