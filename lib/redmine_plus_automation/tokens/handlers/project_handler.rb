module RedminePlusAutomation
  module Tokens
    module Handlers
      class ProjectHandler < BaseHandler
        allowlist_attribute :id, :name, :description, :identifier, :is_public, :status, :created_on, :updated_on
        allowlist_custom_method :url

        def self.custom_field_klass
          @custom_field_klass ||= ProjectCustomField
        end
      end
    end
  end
end
