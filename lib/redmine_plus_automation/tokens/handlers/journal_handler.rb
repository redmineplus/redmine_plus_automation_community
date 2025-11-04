module RedminePlusAutomation
  module Tokens
    module Handlers
      class JournalHandler < BaseHandler
        allowlist_attribute :id, :notes, :private_notes, :created_on, :updated_on
        allowlist_association user: "User", updated_by: "User"
      end
    end
  end
end
