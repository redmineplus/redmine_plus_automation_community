module RedminePlusAutomation
  module Tokens
    module Handlers
      class IssuePriorityHandler < BaseHandler
        allowlist_attribute :id, :name, :is_default, :active
        allowlist_custom_method :url

        def self.custom_field_klass
          @custom_field_klass ||= IssuePriorityCustomField
        end

        def url
          Rails.application.routes.url_helpers.edit_enumeration_url(object, host: Setting.host_name, protocol: Setting.protocol)
        end
      end
    end
  end
end
