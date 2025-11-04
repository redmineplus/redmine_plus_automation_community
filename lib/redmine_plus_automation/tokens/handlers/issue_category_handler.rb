module RedminePlusAutomation
  module Tokens
    module Handlers
      class IssueCategoryHandler < BaseHandler
        allowlist_attribute :id, :name
      end
    end
  end
end
