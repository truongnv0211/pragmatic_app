# This is loaded once before the first command is executed

begin
  require "database_cleaner-active_record"
rescue LoadError => e
  puts e.message
  begin
    require "database_cleaner"
  rescue LoadError => e
    puts e.message
  end
end

begin
  require "factory_bot_rails"
rescue LoadError => e
  puts e.message
  begin
    require "factory_girl_rails"
  rescue LoadError => e
    puts e.message
  end
end

require "cypress_on_rails/smart_factory_wrapper"

factory = CypressOnRails::SimpleRailsFactory
factory = FactoryBot if defined?(FactoryBot)
factory = FactoryGirl if defined?(FactoryGirl)

CypressOnRails::SmartFactoryWrapper.configure(
  always_reload: false,
  factory: factory,
  files: [
    Rails.root.join("spec", "factories.rb"),
    Rails.root.join("spec", "factories", "**", "*.rb")
  ]
)

# require 'vcr'
# VCR.configure do |config|
#   config.hook_into :webmock
# end
