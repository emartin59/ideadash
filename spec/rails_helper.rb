ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start 'rails' do
  add_filter 'app/admin'
  add_filter 'app/inputs'
  add_filter '/config/'
  add_filter '/lib/assets'
  add_filter '/lib/tasks'
  add_filter '/lib/markdown_handler.rb'
  add_filter '/spec/'
  add_filter '/vendor/'
end

require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'

require 'webmock/rspec'

require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
