require 'rubygems'
require 'spork'
require 'capybara/rspec'
require 'capybara/email/rspec'
require 'bcrypt'

BCrypt::Engine::DEFAULT_COST = 1

Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/factories"
    config.use_transactional_fixtures = false
    config.include FactoryGirl::Syntax::Methods

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.before(:all) do
        DeferredGarbageCollection.start
    end

    config.after(:all) do
        DeferredGarbageCollection.reconsider
    end
  end
end

Spork.each_run do
end
