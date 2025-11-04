module RedminePlusAutomation
  module Tokens
    module Handlers
      class VersionHandler < BaseHandler
        allowlist_attribute :id, :name, :description, :effective_date, :created_on, :updated_on, :status, :sharing
        allowlist_custom_method :url

        def self.custom_field_klass
          @custom_field_klass ||= VersionCustomField
        end
      end
    end
  end
end
