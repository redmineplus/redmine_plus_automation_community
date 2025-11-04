module RedminePlusAutomation
  module Tokens
    module Handlers
      class IssueStatusHandler < BaseHandler
        allowlist_attribute :id, :name, :description, :is_closed
        allowlist_custom_method :url
      end
    end
  end
end
