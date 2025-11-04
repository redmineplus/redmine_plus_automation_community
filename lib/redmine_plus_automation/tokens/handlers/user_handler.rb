module RedminePlusAutomation
  module Tokens
    module Handlers
      class UserHandler < BaseHandler
        allowlist_attribute :id, :login, :name, :firstname, :lastname, :admin, :status,
                            :mail, :language, :created_on, :updated_on, :last_login_on
        allowlist_custom_method :url

        def self.custom_field_klass
          @custom_field_klass ||= UserCustomField
        end
      end
    end
  end
end
