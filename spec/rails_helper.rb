# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if
  Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'factory_girl_rails'

require 'support/configure_helper'
require 'support/request_helper'
require 'support/reset_config'
require 'support/shoulda/matchers'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.extend ConfigureHelper
  config.include RequestHelper
  config.include ActiveSupport::Testing::TimeHelpers
end
