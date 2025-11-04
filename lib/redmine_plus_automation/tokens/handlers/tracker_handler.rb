module RedminePlusAutomation
  module Tokens
    module Handlers
      class TrackerHandler < BaseHandler
        allowlist_attribute :id, :name, :description
        allowlist_custom_method :url
      end
    end
  end
end
