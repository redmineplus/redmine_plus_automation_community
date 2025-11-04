# run test
# rspec -Iplugins/redmine_plus_automation/spec  plugins/redmine_plus_automation/spec

ENV['RAILS_ENV'] ||= 'test'

#load rails/redmine
# require File.expand_path('../../../../config/environment', __FILE__)
require File.join(Dir.pwd, 'config/environment')

#test gems
require 'rspec/rails'
# require 'rspec/autorun'
require 'rspec/mocks'
require 'rspec/mocks/standalone'
require 'factory_bot'
require 'webmock/rspec'


# require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true)
# Dir.glob(File.expand_path('./factories/*.rb', __FILE__)).each do |plugin_factory|
#   require plugin_factory
# end

Dir[File.join(File.dirname(__FILE__), '/factories/*.rb')].each { |file| require_relative file }
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# FactoryBot.definition_file_paths << File.expand_path('./factories', __FILE__)
# FactoryBot.find_definitions

module AssertSelectRoot
  def document_root_element
    html_document.root
  end
end

#rspec base config
RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.default_path = 'plugins/redmine_plus_automation/spec'
  # config.fixture_path = "#{::Rails.root}/test/fixtures"
  # config.file_fixture_path = "#{::Rails.root}/plugins/redmine_plus_automation/spec/fixtures/files"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include AssertSelectRoot, :type => :request

  config.before(:each) do |ex|
    meta = ex.metadata
    unless meta[:null]

      allow(Mailer).to receive(:deliver_security_notification).and_return([])
      allow(User).to receive(:current).and_return case meta[:logged]
                                                    when :admin
                                                      FactoryBot.create(:user, language: "en", admin: true)
                                                    when true
                                                      FactoryBot.create(:user, language: "en")
                                                    else
                                                      User.anonymous
                                                    end
    end
  end

end

ActiveRecord::Migration.maintain_test_schema!
